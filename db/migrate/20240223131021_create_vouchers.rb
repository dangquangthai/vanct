class CreateVouchers < ActiveRecord::Migration[7.1]
  def change
    create_table :vouchers do |t|
      t.belongs_to :shift, null: false, foreign_key: true
      t.string :no
      t.datetime :time
      t.string :description
      t.decimal :total
      t.string :kind
      t.timestamps
    end
  end
end
