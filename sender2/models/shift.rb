# frozen_string_literal: true

require 'date'

require_relative 'base_model'

class Shift < BaseModel
  attr_reader :total, :stt, :no, :date

  def initialize(total:, stt:, date: nil)
    @total = total
    @stt = stt
    @date = date || DateTime.now.strftime('%d-%m-%y')
    @no = "#{stt}-#{@date}"
  end

  def self.new_from_no(number:)
    ns = number.split('-')
    new(total: 0, stt: ns.first, date: "20#{ns[3]}-#{ns[2]}-#{ns[1]}")
  end

  def date_to_query
    DateTime.parse(date).strftime('%Y%m%d')
  end

  def access_db_key
    "#{stt}-#{DateTime.parse(date).strftime('%d-%m-%y')}"
  end
end
