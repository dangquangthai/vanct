class CreateBills < ActiveRecord::Migration[7.1]
  def change
    create_table :bills do |t|
      t.belongs_to :shift, null: false, foreign_key: true
      t.string :bill_no
      t.string :table_no
      t.decimal :total

      t.timestamps
    end
  end
end
