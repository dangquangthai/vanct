class AddLabelToSetting < ActiveRecord::Migration[7.1]
  def change
    add_column :settings, :label, :string

    Setting.find_each do |setting|
      setting.update(label: map_name(setting.name))
    end
  end

  def map_name(name)
    Setting::LABELS.fetch(name)
  end
end
