# frozen_string_literal: true

require_relative 'base_model'

class ShiftLine < BaseModel
  def initialize(shift_no:, product_no:, product_name:, product_group:, amount:, price:, unit:, luu_ban:)
    @shift_no = shift_no
    @product_no = product_no
    @product_name = product_name
    @product_group = product_group
    @amount = amount
    @price = price
    @unit = unit
    @bill_no = luu_ban.split('-')[1]
    @table_no = luu_ban.split('-')[2]
    @total = amount * price
  end

  attr_reader :product_no,
              :product_name,
              :product_group,
              :amount,
              :price,
              :unit,
              :bill_no,
              :table_no,
              :shift_no,
              :total
end
