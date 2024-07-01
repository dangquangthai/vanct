class RemoveCustomerIndexes < ActiveRecord::Migration[7.1]
  def change
    rename_table :customers, :tenants
  end
end
