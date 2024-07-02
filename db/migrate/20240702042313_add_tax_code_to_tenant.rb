class AddTaxCodeToTenant < ActiveRecord::Migration[7.1]
  def change
    add_column :tenants, :tax_code, :string
  end
end
