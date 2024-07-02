class CreateAnotherCustomers < ActiveRecord::Migration[7.1]
  def change
    # MATHE, MAST, HOTEN, EMAIL, DIACHI, DIENTHOAI, DENHAN, DIEM, PHANTRAM, GHICHU
    create_table :customers do |t|
      t.string :no
      t.string :tax_code
      t.string :legal_name
      t.string :email
      t.string :address
      t.string :phone_number
      t.datetime :expired_at
      t.float :point
      t.float :percentage
      t.text :note
      t.timestamps
    end
  end
end
