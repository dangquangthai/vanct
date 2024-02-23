class RenameDescriptionToNote < ActiveRecord::Migration[7.1]
  def change
    rename_column :vouchers, :description, :note
  end
end
