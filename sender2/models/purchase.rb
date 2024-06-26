# frozen_string_literal: true

require_relative 'base_model'

class Purchase < BaseModel
  attr_reader :no, :time, :tt, :sdt, :ncc, :pno, :name, :gname, :unit, :price, :sl, :stk

  def initialize(no:, time:, sdt:, ncc:, pno:, name:, gname:, unit:, price:, sl:, tt:, stk:)
    @no = no
    @time = time
    @sdt = sdt # phone number
    @ncc = ncc # provider_name
    @pno = pno
    @name = name
    @gname = gname
    @unit = unit
    @price = price
    @sl = sl
    @tt = tt
    @stk = stk
  end
end
