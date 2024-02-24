# frozen_string_literal: true

KEY = 'Tuans'
PATH = 'D:\Phan mem tinh tien 4.0\SyncData\Datashare.mdb'
PASSWORD = '26331'
WEBSITE = 'http://vanct.vn'

require 'win32ole'
require_relative 'services/access_db'
require_relative 'services/db_reader'
require_relative 'services/api_client'
require_relative 'services/live'
require_relative 'services/sync'

db = AccessDb.new(path: PATH, password: PASSWORD)
reader = DbReader.new(db: db)
api_client = ApiClient.new(endpoint: WEBSITE, key: KEY)
live = Live.new(reader: reader, api_client: api_client)
sync = Sync.new(reader: reader, api_client: api_client)
info = api_client.info
p info
db.open
info['sql'].each { |sql| db.execute(sql) }
live.perform if info['live']
sync.perform if info['sync']
# p reader.current_shift.to_hash
# p reader.shifts(as_hash: true)
# shift = Shift.new(total: 0, stt: '1', date: '2023-11-18')
# p shift.to_hash
# p api_client.sync_vouchers({ shift_no: shift.no, vouchers: reader.vouchers(shift, as_hash: true) })
# p api_client.sync_products({ products: reader.products(as_hash: true) })
db.close
