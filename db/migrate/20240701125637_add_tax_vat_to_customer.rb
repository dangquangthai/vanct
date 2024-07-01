class AddTaxVatToCustomer < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :tax_vat_value, :integer, default: 10
    add_column :customers, :tax_vat_inclusion, :boolean, default: false
  end
end
