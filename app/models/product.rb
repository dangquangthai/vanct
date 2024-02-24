# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :customer

  def queue_update_to_desktop
    enqueued = customer.sql_enqueued
    enqueued << to_update_sql_statement
    Cache.write(customer.sql_statement_key, enqueued.to_json)
  end

  def to_update_sql_statement
    updated_attrs = {
      'TENHANG' => name,
      'NHOM' => gname,
      'MUC' => cname,
      'DVT' => unit,
      'DONGIA' => price.to_i,
      'DONGIA1' => price1.to_i
    }

    sql_params = updated_attrs.keys.map { |k| "#{k}=?" }.join(', ')
    sql = self.class.sanitize_sql_array([sql_params] + updated_attrs.values)

    "update [DANH MUC HANG] set #{sql} where MAHG='#{no}';"
  end
end
