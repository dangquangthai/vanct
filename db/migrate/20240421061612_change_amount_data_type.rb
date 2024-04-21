class ChangeAmountDataType < ActiveRecord::Migration[7.1]
  def change
    change_column :purchase_lines, :amount, :float
    change_column :bill_lines, :amount, :float
  end
end
