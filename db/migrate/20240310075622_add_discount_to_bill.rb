class AddDiscountToBill < ActiveRecord::Migration[7.1]
  def change
    add_column :bills, :discount, :decimal, default: 0
  end
end
