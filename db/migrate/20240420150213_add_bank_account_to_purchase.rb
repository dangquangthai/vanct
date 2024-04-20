class AddBankAccountToPurchase < ActiveRecord::Migration[7.1]
  def change
    add_column :purchases, :bank_account, :string
  end
end
