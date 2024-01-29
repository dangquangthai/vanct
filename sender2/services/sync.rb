# frozen_string_literal: true

require 'json'

class Sync
  def initialize(reader:, api_client:)
    @api_client = api_client
    @reader = reader
  end

  attr_reader :reader, :api_client

  def perform
    reader.shifts.each do |shift|
      lines = reader.shift_lines(shift, as_hash: true)
      next if lines.empty?

      api_client.sync({ shift_lines: lines })
    end
  end
end
