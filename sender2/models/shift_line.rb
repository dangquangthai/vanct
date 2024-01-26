# frozen_string_literal: true

class ShiftLine
  def initialize(product_no:, product_name:, product_group:, amount:, price:, unit:, bill_no:)
    @product_no = product_no
    @product_name = product_name
    @product_group = product_group
    @amount = amount
    @price = price
    @unit = unit
    @bill_no = bill_no
  end

  attr_reader :product_no,
              :product_name,
              :product_group,
              :amount,
              :price,
              :unit,
              :bill_no
end
