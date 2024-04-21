class ChangeAmountDataType1 < ActiveRecord::Migration[7.1]
  def change
    change_column :purchase_lines, :amount, :decimal
    change_column :bill_lines, :amount, :decimal
  end
end
