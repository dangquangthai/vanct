# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :customer

  def queue_update_to_desktop
    enqueued = customer.sql_enqueued
    enqueued << to_update_sql_statement
    Cache.write(customer.sql_statement_key, enqueued.to_json)
  end

  def queue_insert_to_desktop
    enqueued = customer.sql_enqueued
    enqueued << to_insert_sql_statement
    Cache.write(customer.sql_statement_key, enqueued.to_json)
  end

  protected

  def to_update_sql_statement
    attrs = {
      'TENHANG' => name,
      'NHOM' => gname,
      'MUC' => cname,
      'DVT' => unit,
      'DONGIA' => price.to_i,
      'DONGIA1' => price1.to_i
    }

    sql_params = attrs.keys.map { |k| "#{k}=?" }.join(', ')
    sql = self.class.sanitize_sql_array([sql_params] + attrs.values)

    "update [DANH MUC HANG] set #{sql} where MAHG='#{no}';"
  end

  def to_insert_sql_statement
    attrs = {
      'MAHG' => no,
      'TENHANG' => name,
      'NHOM' => gname,
      'MUC' => cname,
      'DVT' => unit,
      'DONGIA' => price.to_i,
      'DONGIA1' => price1.to_i
    }

    sql_columns = attrs.keys.map { |k| k }.join(', ')
    sql_params = attrs.keys.map { |_| '?' }.join(', ')
    sql = self.class.sanitize_sql_array([sql_params] + attrs.values)

    "INSERT INTO [DANH MUC HANG] (#{sql_columns}) VALUES(#{sql});"
  end
end
