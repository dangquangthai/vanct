# frozen_string_literal: true

require 'json'

class Sync
  def initialize(reader:, api_client:)
    @api_client = api_client
    @reader = reader
    @has_new_shitf = false
  end

  attr_reader :reader, :api_client, :has_new_shitf, :sync_voucher, :sync_purchase

  def perform(config)
    sync_shifts
    @sync_voucher = config['sync_voucher']
    @sync_purchase = config['sync_purchase']

    return unless has_new_shitf

    sync_products
    sync_inventories if info['sync_inventory']
    sync_settings
    sync_customers
  end

  protected

  def sync_shifts
    reader.shifts.each do |shift|
      lines = reader.shift_lines(shift, as_hash: true)
      next if lines.empty?

      api_client.sync_shift({ shift_lines: lines })
      api_client.sync_vouchers({ shift_no: shift.no, vouchers: reader.vouchers(shift, as_hash: true) }) if sync_voucher
      api_client.sync_purchases({ shift_no: shift.no, purchases: reader.purchases(shift, as_hash: true) }) if sync_purchase

      mark_as_synced!(shift)
      @has_new_shitf = true
    end
  end

  def sync_products
    api_client.sync_products({ products: reader.products(as_hash: true) })
  end

  def sync_inventories
    api_client.sync_inventories({ inventories: reader.inventories(as_hash: true) })
  end

  def sync_settings
    api_client.sync_settings({ settings: reader.settings(as_hash: true) })
  end

  def sync_customers
    api_client.sync_customers({ customers: reader.customers(as_hash: true) })
  end

  def mark_as_synced!(shift)
    if sync_purchase
      sql = "update [CHI TIET NHAP HANG] set DADONGBO=true where CA=\"#{shift.stt}\" and Val(Format (NGAY, \"yyyymmdd\"))=\"#{shift.date_to_query}\";"
      reader.db.execute(sql)
    end

    sql = "update [DA KET SO] set DADONGBO=true where MAKETSO=\"#{shift.access_db_key}\";"
    reader.db.execute(sql)
  end
end
