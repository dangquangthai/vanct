# frozen_string_literal: true

KEY = 'ace'
PATH = 'D:\sender2\database\Datashare(NGOCTUYET)2.mdb'
PASSWORD = '26331'
WEBSITE = 'https://d4da-27-69-181-208.ngrok-free.app'

require 'win32ole'
require_relative 'services/access_db'
require_relative 'services/db_reader'
require_relative 'services/api_client'
require_relative 'services/live'
require_relative 'services/sync'

db = AccessDb.new(path: PATH, password: PASSWORD)
reader = DbReader.new(db: db)
api_client = ApiClient.new(endpoint: WEBSITE, key: KEY)
Live.new(reader: reader, api_client: api_client)
sync = Sync.new(reader: reader, api_client: api_client)
info = api_client.info
p info
db.open
# live.perform if !!info['live']
sync.perform unless info['sync'].nil?
db.close
