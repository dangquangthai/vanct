class AddFeatureToCustomer < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :sync_purchase, :boolean, default: false
    add_column :customers, :sync_inventory, :boolean, default: false
    add_column :customers, :sync_voucher, :boolean, default: false
  end
end
