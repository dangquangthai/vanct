# frozen_string_literal: true

require_relative 'base_model'

class ShiftLine < BaseModel
  def initialize(shift_no:, product_no:, product_name:, product_group:, amount:, price:, unit:, bill_ref:)
    @shift_no = shift_no
    @product_no = product_no
    @product_name = product_name
    @product_group = product_group
    @amount = amount
    @price = price
    @unit = unit
    @bill_ref = bill_ref
  end

  attr_reader :shift_no,
              :product_no,
              :product_name,
              :product_group,
              :amount,
              :price,
              :unit,
              :bill_ref
end
