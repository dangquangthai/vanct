# frozen_string_literal: true

KEY = ''
PATH = 'D:\sender2\database\Datashare(NGOCTUYET).mdb'
PASSWORD = '26331'

require 'win32ole'
require_relative 'services/access_db'
require_relative 'services/db_reader'

db = AccessDb.new(path: 'D:\sender2\database\Datashare(NGOCTUYET).mdb', password: '26331')
db.open

reader = DbReader.new(db: db)
p reader.tables
p reader.table_lines
p reader.shifts

db.close
