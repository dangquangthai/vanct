# frozen_string_literal: true

class TableLine
  def initialize(table_no:, product_name:, product_no:, amount:, price:, unit:, product_group:, order_time:, da_bao:)
    @table_no = table_no
    @product_name = product_name
    @product_no = product_no
    @amount = amount
    @price = price
    @unit = unit
    @product_group = product_group
    @order_time = order_time
    @da_bao = da_bao
  end

  attr_reader :table_no,
              :product_name,
              :product_no,
              :amount,
              :price,
              :unit,
              :product_group,
              :order_time,
              :da_bao
end
