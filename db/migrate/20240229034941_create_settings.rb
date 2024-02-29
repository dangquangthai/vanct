class CreateSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :settings do |t|
      t.belongs_to :customer, null: false, foreign_key: true
      t.string :name
      t.string :value
      t.timestamps
    end
  end
end
