# frozen_string_literal: true

class Shift < ApplicationRecord
  belongs_to :customer
  has_many :bills, dependent: :destroy
  has_many :vouchers, dependent: :destroy
  has_many :inventories, dependent: :destroy

  def queue_update_to_desktop
    enqueued = customer.sql_enqueued
    enqueued << to_update_sql_statement
    Cache.write(customer.sql_statement_key, enqueued.to_json)
  end

  protected

  def to_update_sql_statement
    access_db_key = "#{stt}-#{shift_date.strftime('%d-%m-%y')}"
    "update [DA KET SO] set DADONGBO=false where MAKETSO=\"#{access_db_key}\";"
  end
end
