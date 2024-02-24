# frozen_string_literal: true

require 'json'

class Sync
  def initialize(reader:, api_client:)
    @api_client = api_client
    @reader = reader
    @has_new_shitf = false
  end

  attr_reader :reader, :api_client, :has_new_shitf

  def perform
    sync_shifts
    sync_products if has_new_shitf
  end

  protected

  def sync_shifts
    reader.shifts.each do |shift|
      lines = reader.shift_lines(shift, as_hash: true)
      next if lines.empty?

      api_client.sync_shift({ shift_lines: lines })
      api_client.sync_vouchers({ shift_no: shift.no, vouchers: reader.vouchers(shift, as_hash: true) })

      mark_as_synced!(shift)
      @has_new_shitf = true
    end
  end

  def sync_products
    api_client.sync_products({ products: reader.products(as_hash: true) })
  end

  def mark_as_synced!(shift)
    sql = "update [DA KET SO] set DADONGBO=true where MAKETSO=\"#{shift.access_db_key}\";"
    reader.db.execute(sql)
  end
end
