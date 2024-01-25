class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :key
      t.date :expires_at
      t.boolean :enabled, default: true
      t.boolean :sync_data, default: false
      t.timestamps
    end
  end
end
