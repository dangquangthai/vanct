# frozen_string_literal: true

KEY = 'ace'
PATH = 'D:\sender2\database\Datashare(NGOCTUYET).mdb'
PASSWORD = '26331'
WEBSITE = 'https://d08d-27-69-181-208.ngrok-free.app'

require 'win32ole'
require_relative 'services/access_db'
require_relative 'services/db_reader'
require_relative 'services/api_client'
require_relative 'services/live'

db = AccessDb.new(path: PATH, password: PASSWORD)
reader = DbReader.new(db: db)
api_client = ApiClient.new(endpoint: WEBSITE, key: KEY)
live = Live.new(reader: reader, api_client: api_client)

db.open

live.perform

# p reader.tables(to_hash: true)
# p reader.table_lines(to_json: true)

# shift = reader.current_shift
# p shift.to_hash
# p reader.shift_lines(shift, to_json: true)
# p api_client.info
# p reader.shifts(to_json: true)

db.close
