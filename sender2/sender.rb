# frozen_string_literal: true

KEY = ''
PATH = 'D:\sender2\database\Datashare(NGOCTUYET).mdb'
PASSWORD = '26331'
WEBSITE = 'https://d08d-27-69-181-208.ngrok-free.app'

require 'win32ole'
require_relative 'services/access_db'
require_relative 'services/db_reader'
require_relative 'services/api_client'

db = AccessDb.new(path: PATH, password: PASSWORD)
api_client = ApiClient.new(endpoint: WEBSITE, key: KEY)

db.open

reader = DbReader.new(db: db)
p reader.tables
p reader.table_lines

shift = reader.current_shift
p shift
p reader.shift_lines(shift)
p reader.shifts

p api_client.info

db.close
