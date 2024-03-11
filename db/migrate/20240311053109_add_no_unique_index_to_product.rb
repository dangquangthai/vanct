class AddNoUniqueIndexToProduct < ActiveRecord::Migration[7.1]
  def change
    add_index :products, [:customer_id, :no], unique: true
  end
end
