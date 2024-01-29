class CreateShifts < ActiveRecord::Migration[7.1]
  def change
    create_table :shifts do |t|
      t.belongs_to :customer, null: false, foreign_key: true
      t.string :no
      t.string :stt
      t.string :date
      t.decimal :total
      
      t.timestamps
    end
  end
end
