class UniqueCustomerKey < ActiveRecord::Migration[7.1]
  def change
    add_index :customers, :key, unique: true
  end
end
