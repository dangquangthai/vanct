# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :tenant

  attr_accessor :have_to_validate

  validates :no, :name, :gname, :cname, :unit, :price, :price1,
            presence: { message: 'vui lòng nhập giá trị' },
            if: -> { have_to_validate == true }

  validates :no, uniqueness: { scope: :tenant_id, message: 'đã sử dụng' }, if: -> { have_to_validate == true }

  def queue_update_to_desktop
    enqueued = tenant.sql_enqueued
    enqueued << to_update_sql_statement
    Cache.write(tenant.sql_statement_key, enqueued.to_json)
  end

  def queue_insert_to_desktop
    enqueued = tenant.sql_enqueued
    enqueued << to_insert_sql_statement
    Cache.write(tenant.sql_statement_key, enqueued.to_json)
  end

  protected

  def update_attributes
    @update_attributes ||= {
      'TENHANG' => name,
      'NHOM' => gname,
      'MUC' => cname,
      'DVT' => unit,
      'DONGIA' => price.to_i,
      'DONGIA1' => price1.to_i
    }
  end

  def to_update_sql_statement
    sql_params = update_attributes.keys.map { |k| "#{k}=?" }.join(', ')
    sql = self.class.sanitize_sql_array([sql_params] + update_attributes.values)

    "UPDATE [DANH MUC HANG] set #{sql} WHERE MAHG='#{no}';"
  end

  def to_insert_sql_statement
    attrs = { 'MAHG' => no }.merge(update_attributes)

    sql_columns = attrs.keys.map { |k| k }.join(', ')
    sql_params = attrs.keys.map { |_| '?' }.join(', ')
    sql = self.class.sanitize_sql_array([sql_params] + attrs.values)

    "INSERT INTO [DANH MUC HANG] (#{sql_columns}) VALUES(#{sql});"
  end
end
