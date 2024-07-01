# frozen_string_literal: true

class Setting < ApplicationRecord
  belongs_to :tenant

  KEYS = %w[MATKHAU NOIDUNG GIAM SUA IN GIATET].freeze
  BOOLEAN_KEYS = %w[SUA IN GIATET].freeze
  SYSTEM_KEYS = %w[WEBKEY NGAYHETHAN HOATDONG].freeze
  LABELS = {
    'MATKHAU' => 'Mật khẩu',
    'NOIDUNG' => 'Tiêu đề cuối bill',
    'GIAM' => '%Tăng, giảm giá mặc định',
    'SUA' => 'Trả món sau in bill',
    'IN' => 'In order',
    'GIATET' => 'Bán giá tết'
  }.freeze

  def queue_update_to_desktop
    enqueued = tenant.sql_enqueued
    enqueued << to_update_sql_statement
    Cache.write(tenant.sql_statement_key, enqueued.to_json)
  end

  def boolean?
    name.in?(BOOLEAN_KEYS)
  end

  protected

  def to_update_sql_statement
    self.class.sanitize_sql_array(["update [TUY CHON] set `#{name}`=?;", value])
  end
end
