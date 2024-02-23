class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.belongs_to :customer, null: false, foreign_key: true
      t.string :no
      t.string :name
      t.string :gname
      t.string :cname
      t.string :unit
      t.decimal :price
      t.decimal :price1
      t.timestamps
    end
  end
end
