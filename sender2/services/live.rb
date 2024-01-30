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
      save_data_to_file
      api_client.live(data)
    end

    return unless data_has_changed?

    save_data_to_file
    api_client.live(data)
  end

  protected

  def data_has_changed?
    previous_data = JSON.parse(File.open(file_path).read)
    previous_data['table_lines'].count != data[:table_lines].count ||
      previous_data['shift']['total'] != data[:shift].total ||
      previous_data['tables'].count { |t| t['busy'] } != data[:tables].count(&:busy)
  end

  def save_data_to_file
    File.open(file_path, 'w+') { |f| f.write(data.to_json) }
  end

  def data
    @data ||= {
      tables: reader.tables(as_hash: true),
      table_lines: reader.table_lines(as_hash: true),
      shift: reader.current_shift.to_hash
    }
  end

  def file_existing?
    File.exist?(file_path)
  end

  def file_path
    'data'
  end
end
