# frozen_string_literal: true

class Table
  def initialize(table_no:, busy:, has_change:, printed:, stt:, in_time:, out_time:, discount:, staff:)
    @table_no = table_no
    @busy = busy
    @has_change = has_change
    @printed = printed
    @stt = stt
    @in_time = in_time
    @out_time = out_time
    @discount = discount
    @staff = staff
  end

  attr_reader :table_no,
              :busy,
              :has_change,
              :printed,
              :stt,
              :in_time,
              :out_time,
              :discount,
              :staff
end
