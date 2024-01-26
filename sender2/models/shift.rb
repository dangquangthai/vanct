# frozen_string_literal: true

require 'date'

class Shift
  def initialize(total:, stt:, date: nil)
    @total = total
    @stt = stt
    @date = date || Time.now
    @name = "#{stt}-#{@date.strftime('%d-%m-%y')}"
  end

  def self.new_from_name(name:)
    names = name.split('-')
    stt = names.first
    date = DateTime.parse("20#{names[3]}-#{names[2]}-#{names[1]}")
    new(total: 0, stt: stt, date: date)
  end

  attr_reader :total, :stt, :name, :date

  def mark_as_synced!(db)
    sql = "update [DA KET SO] set DADONGBO=true where MAKETSO=\"#{name}\";"
    db.execute(sql)
  end
end
