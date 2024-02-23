# frozen_string_literal: true

require 'json'

class Sync
  def initialize(reader:, api_client:)
    @api_client = api_client
    @reader = reader
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

      api_client.sync({ shift_lines: lines })

      mark_as_synced!(shift)
      sync_vouchers(shift)
      @has_new_shitf = true
    end
  end

  def sync_products
    reader.products.each do |h|
    end
  end

  def sync_vouchers(shift)
    reader.vouchers(shift).each do |h|

    end
  end

  def mark_as_synced!(shift)
    sql = "update [DA KET SO] set DADONGBO=true where MAKETSO=\"#{shift.access_db_key}\";"
    reader.db.execute(sql)
  end
end
