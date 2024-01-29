# frozen_string_literal: true

require 'json'

class Live
  def initialize(reader:, api_client:)
    @api_client = api_client
    @reader = reader
  end

  attr_reader :reader, :api_client

  def performable?
    p api_client.info
    api_client.info['success']
  end

  def perform
    unless file_existing?
      p 'File not found, creating new file'
      save_data_to_file
      api_client.live(data)
    end

    return unless data_has_changed?

    p 'Data has changed, sending to server'
    save_data_to_file
    api_client.live(data)
  end

  def data_has_changed?
    JSON.parse(File.open(file_path).read) == data
  end

  def save_data_to_file
    File.open(file_path, 'w+') { |f| f.write(data.to_json) }
  end

  def data
    @data ||= {
      tables: reader.tables(to_hash: true),
      table_lines: reader.table_lines(to_hash: true),
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
