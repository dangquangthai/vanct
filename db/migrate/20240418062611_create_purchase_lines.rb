class CreatePurchaseLines < ActiveRecord::Migration[7.1]
  def change
    create_table :purchase_lines do |t|
      t.belongs_to :purchase, null: false, foreign_key: true
      t.datetime :time
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
