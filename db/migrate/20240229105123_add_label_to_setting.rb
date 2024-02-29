class AddLabelToSetting < ActiveRecord::Migration[7.1]
  def change
    add_column :settings, :label, :string

    Setting.find_each do |setting|
      setting.update(label: map_name(setting.name))
    end
  end

  def map_name(name)
    {
      'MATKHAU' => 'Mật khẩu',
      'NOIDUNG' => 'Tiêu đề cuối bill',
      'GIAM' => '%Tăng, giảm giá mặc định',
      'SUA' => 'Trả món sau in bill',
      'IN' => 'In order',
      'GIATET' => 'Bán giá tết'
    }.fetch(name)
  end
end
