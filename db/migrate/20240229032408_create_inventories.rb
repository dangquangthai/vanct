class CreateInventories < ActiveRecord::Migration[7.1]
  def change
    create_table :inventories do |t|
      t.belongs_to :shift, null: false, foreign_key: true
      t.string :no
      t.string :name
      t.string :unit
      t.decimal :open
      t.decimal :input
      t.decimal :output
      t.decimal :close
      t.timestamps
    end
  end
end
