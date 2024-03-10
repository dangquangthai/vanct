# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :shifts, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :settings, dependent: :destroy

  validates :key, presence: true, uniqueness: true
  validates :name, :expires_at, presence: true

  scope :without_ace, -> { where.not('LOWER(key) = ?', 'ace') }

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
    enqueued = sql_enqueued
    enqueued << to_update_web_key_sql_statement
    enqueued << to_update_enabled_sql_statement
    enqueued << to_update_expires_at_data_sql_statement
    Cache.write(sql_statement_key, enqueued.to_json)
  end

  def sync_live_data!
    enqueued = sql_enqueued
    enqueued << 'DELETE FROM [BAN];'

    live_data['tables'].map do |t|
      enqueued << build_table_sql(t)
      raw['lines'].each { |l| enqueued << build_table_line_sql(l) }
    end

    Cache.write(sql_statement_key, enqueued.to_json)
  end

  def sync_products!
    products.map(&:queue_insert_to_desktop)
  end

  protected

  def build_table_line_sql(raw)
    order_time = Time.zone.parse(raw['order_time'])
    attrs = {
      'SOBAN' => raw['table_no'],
      'MAHG' => raw['product_no'],
      'TENHANG' => raw['product_name'],
      'SOLUONG' => raw['amount'],
      'DONGIA' => raw['price'],
      'DVT' => raw['unit'],
      'NHOM' => raw['product_group'],
      'DABAO' => raw['da_bao'],
      'NGAY' => order_time.strftime('%d/%m/%y'),
      'GIO' => order_time.strftime('%H:%M:%S'),
      'QUAY' => raw['cabin'],
      'MANV' => raw['staff'],
      'INCHUA' => raw['inor'],
      'MAQL' => raw['no'],
      'XUAT' => raw['stt']
    }

    sql_columns = attrs.keys.map { |k| k }.join(', ')
    sql_params = attrs.keys.map { |_| '?' }.join(', ')
    sql = self.class.sanitize_sql_array([sql_params] + attrs.values)

    "INSERT INTO [BAN] (#{sql_columns}) VALUES(#{sql});"
  end

  def build_table_sql(raw)
    in_time = raw['in_time'].present? ? Time.zone.parse(raw['in_time']).strftime('%d/%m/%y %H:%M:%S') : nil
    out_time = raw['out_time'].present? ? Time.zone.parse(raw['out_time']).strftime('%d/%m/%y %H:%M:%S') : nil
    attrs = {
      'COKHACH' => raw['busy'],
      'CODOI' => raw['has_change'],
      'INBILL' => raw['printed'],
      'STT' => raw['stt'],
      'GIOVAO' => in_time,
      'GIORA' => out_time,
      'GIAM' => raw['discount'],
      'PHUCVU' => raw['staff']
    }

    sql_params = attrs.keys.map { |k| "`#{k}`=?" }.join(', ')
    sql = self.class.sanitize_sql_array([sql_params] + attrs.values)
    "update [DANH MUC BAN] set #{sql} where MABAN='#{raw['table_no']}';"
  end

  def to_update_web_key_sql_statement
    self.class.sanitize_sql_array(['update [TUY CHON] set `WEBKEY`=?;', key])
  end

  def to_update_enabled_sql_statement
    self.class.sanitize_sql_array(['update [TUY CHON] set `HOATDONG`=?;', enabled ? '1' : '0'])
  end

  def to_update_expires_at_data_sql_statement
    self.class.sanitize_sql_array(['update [TUY CHON] set `NGAYHETHAN`=?;', expires_at.strftime('%d/%m/%y')])
  end
end
