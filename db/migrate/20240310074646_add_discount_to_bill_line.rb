class AddDiscountToBillLine < ActiveRecord::Migration[7.1]
  def change
    add_column :bill_lines, :discount, :decimal, default: 0
  end
end
