# frozen_string_literal: true

require 'json'

class Live
  def initialize(reader:, api_client:)
    @api_client = api_client
    @reader = reader
  end

  attr_reader :reader, :api_client

  def perform
    unless file_existing?
      api_client.live(data)
      save_data_to_file
      return
    end

    return unless data_has_changed?

    api_client.live(data)
    save_data_to_file
  end

  protected

  def data_has_changed?
    previous_data = JSON.parse(File.open(file_path).read || empty_data.to_json)
    previous_data['lines'].count != data['lines'].count ||
      previous_data['table_lines'].count != data['table_lines'].count ||
      previous_data['shift']['total'] != data['shift']['total'] ||
      previous_data['tables'].count { |t| t['busy'] } != data['tables'].count { |t| t['shift'] }
  end

  def empty_data
    {
      tables: [],
      table_lines: [],
      lines: [],
      shift: {
        total: -1
      }
    }
  end

  def save_data_to_file
    File.open(file_path, 'w+') { |f| f.write(data.to_json) }
  end

  def data
    @data ||= {
      'tables' => reader.tables(as_hash: true),
      'table_lines' => table_lines.select { |l| l['table_no'] && !l['bno'] },
      'lines' => table_lines.select { |l| !l['table_no'] && l['bno'] },
      'shift' => reader.current_shift.to_hash
    }
  end

  def table_lines
    @table_lines ||= reader.table_lines(as_hash: true)
  end

  def file_existing?
    File.exist?(file_path)
  end

  def file_path
    'data'
  end
end
