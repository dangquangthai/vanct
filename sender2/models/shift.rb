# frozen_string_literal: true

require 'date'

require_relative 'base_model'

class Shift < BaseModel
  def initialize(total:, stt:, date: nil)
    @total = total
    @stt = stt
    @date = date || DateTime.now.strftime('%d-%m-%y')
    @name = "#{stt}-#{@date}"
  end

  def self.new_from_name(name:)
    names = name.split('-')
    new(total: 0, stt: names.first, date: "20#{names[3]}-#{names[2]}-#{names[1]}")
  end

  attr_reader :total, :stt, :name, :date

  def mark_as_synced!(db)
    sql = "update [DA KET SO] set DADONGBO=true where MAKETSO=\"#{name}\";"
    db.execute(sql)
  end

  def date_to_query
    dates = name.split('-')
    DateTime.parse("20#{dates[3]}-#{dates[2]}-#{dates[1]}").strftime('%Y%m%d')
  end
end
