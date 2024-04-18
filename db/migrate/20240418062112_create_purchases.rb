class CreatePurchases < ActiveRecord::Migration[7.1]
  def change
    create_table :purchases do |t|
      t.belongs_to :shift, null: false, foreign_key: true
      t.string :no
      t.decimal :total
      t.boolean :paid, default: false
      t.string :provider_name
      t.string :phone_number
      t.datetime :time
      t.timestamps
    end
  end
end
