# frozen_string_literal: true

class Shift
  def initialize(total:, stt:)
    @total = total
    @stt = stt
    @date = Time.zone.now.strftime('%d-%m-%y')
    @name = "#{stt}-#{@date}"
  end

  attr_reader :total, :stt, :name, :date
end
