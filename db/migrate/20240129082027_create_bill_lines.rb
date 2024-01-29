class CreateBillLines < ActiveRecord::Migration[7.1]
  def change
    create_table :bill_lines do |t|
      t.belongs_to :bill, null: false, foreign_key: true
      t.string :product_no
      t.string :product_name
      t.string :product_group
      t.integer :amount
      t.decimal :price
      t.string :unit
      t.decimal :total
      
      t.timestamps
    end
  end
end
