class RenameCustomerIdColumns < ActiveRecord::Migration[7.1]
  def change
    rename_column :products, :customer_id, :tenant_id
    rename_column :settings, :customer_id, :tenant_id
    rename_column :shifts, :customer_id, :tenant_id
    rename_column :users, :customer_id, :tenant_id
  end
end
