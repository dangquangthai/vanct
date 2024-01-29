class ChangeShiftDate < ActiveRecord::Migration[7.1]
  def change
    remove_column :shifts, :date

    change_table :shifts do |t|
      t.date :shift_date
    end
  end
end
