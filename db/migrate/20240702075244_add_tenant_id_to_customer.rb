class AddTenantIdToCustomer < ActiveRecord::Migration[7.1]
  def change
    change_table :customers do |t|
      t.belongs_to :tenant, null: false, foreign_key: true
    end
  end
end
