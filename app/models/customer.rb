# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :shifts, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :settings, dependent: :destroy

  validates :key, presence: true, uniqueness: true
  validates :name, :expires_at, presence: true

  def expired?
    expires_at < Time.current
  end

  def online?
    return false if last_seen_at.nil?

    last_seen_at > 5.minutes.ago
  end

  def update_last_see_at!
    update!(last_seen_at: Time.current) unless online?
  end

  def live?
    !expired? && enabled? && online?
  end

  def sync?
    !expired? && enabled? && sync_data?
  end

  def sql_statement_key
    "sql_statement_#{key}"
  end

  def live_data_key
    "live_data_#{key}"
  end

  def live_data
    JSON.parse(Cache.read(live_data_key) || '{}')
  end

  def live_data_exist?
    Cache.exist?(live_data_key)
  end

  def sql_enqueued
    JSON.parse(Cache.read(sql_statement_key) || '[]')
  end

  def discard_sql_enqueued
    Cache.discard(sql_statement_key)
  end

  def live_data_expired?
    return true if live_data['updated_at'].blank?

    live_data['updated_at'].first(10) != Current.ftime.first(10)
  end

  def delete_live_data_if_expired!
    return unless live_data_exist?
    return unless live_data_expired?

    Cache.discard(live_data_key)
  end

  def init_settings
    Setting::KEYS.each do |key|
      settings.create(name: key, label: Setting::LABELS.fetch(key))
    end
  end

  def queue_update_settings_to_desktop
    enqueued = customer.sql_enqueued
    enqueued << to_update_app_key_sql_statement
    enqueued << to_update_enabled_sql_statement
    enqueued << to_update_expires_at_data_sql_statement
    Cache.write(customer.sql_statement_key, enqueued.to_json)
  end

  protected

  def to_update_app_key_sql_statement
    self.class.sanitize_sql_array(['update [TUY CHON] set `APPKEY`=?;', key])
  end

  def to_update_enabled_sql_statement
    self.class.sanitize_sql_array(['update [TUY CHON] set `HOATDONG`=?;', enabled ? '1' : '0'])
  end

  def to_update_expires_at_data_sql_statement
    self.class.sanitize_sql_array(['update [TUY CHON] set `NGAYHETHAN`=?;', expires_at.to_s])
  end
end
