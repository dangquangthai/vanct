# frozen_string_literal: true

require_relative 'base_model'

class TableLine < BaseModel
  def initialize(table_no:, product_name:, product_no:, amount:, price:, unit:, product_group:, order_time:, da_bao:, cabin:, staff:, inor:, no:, stt:)
    @table_no = table_no
    @product_name = product_name
    @product_no = product_no
    @amount = amount
    @price = price
    @unit = unit
    @product_group = product_group
    @order_time = order_time
    @da_bao = da_bao
    @total = amount * price
    @cabin = cabin
    @staff = staff
    @inor = inor
    @no = no
    @stt = stt
  end

  attr_reader :table_no,
              :product_name,
              :product_no,
              :amount,
              :price,
              :unit,
              :product_group,
              :order_time,
              :da_bao,
              :total,
              :cabin,
              :staff,
              :inor,
              :no,
              :stt
end
