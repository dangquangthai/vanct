# frozen_string_literal: true

KEY = 'test'
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
sync = Sync.new(reader: reader, api_client: api_client)
config = api_client.verify_data('sync_data')
db.open
config['sql'].each { |sql| db.execute(sql) }
sync.perform(config) if config['sync']
# shifts = reader.shifts
# puts reader.purchases(shifts.first, as_hash: true).to_json
# puts reader.purchases(shifts.last, as_hash: true).to_json
# puts reader.customers(as_hash: true).to_json
db.close
