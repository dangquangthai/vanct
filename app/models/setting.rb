# frozen_string_literal: true

class Setting < ApplicationRecord
  belongs_to :customer

  KEYS = %w[MATKHAU NOIDUNG GIAM SUA IN GIATET].freeze

  def queue_update_to_desktop
    enqueued = customer.sql_enqueued
    enqueued << to_update_sql_statement
    Cache.write(customer.sql_statement_key, enqueued.to_json)
  end

  protected

  def to_update_sql_statement
    self.class.sanitize_sql_array(["update [TUY CHON] set #{name}=?;", value])
  end
end
