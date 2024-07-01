# frozen_string_literal: true

class Shift < ApplicationRecord
  belongs_to :tenant
  has_many :bills, dependent: :destroy
  has_many :vouchers, dependent: :destroy
  has_many :inventories, dependent: :destroy
  has_many :purchases, dependent: :destroy

  def queue_update_to_desktop
    enqueued = tenant.sql_enqueued
    enqueued << to_update_sql_statement
    Cache.write(tenant.sql_statement_key, enqueued.to_json)
  end

  protected

  def to_update_sql_statement
    access_db_key = "#{stt}-#{shift_date.strftime('%d-%m-%y')}"
    "update [DA KET SO] set DADONGBO=false where MAKETSO=\"#{access_db_key}\";"
  end
end
