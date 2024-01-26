# frozen_string_literal: true

require 'win32ole'

class AccessDb
  attr_reader :path, :connection, :data, :fields, :connection_string

  def initialize(path:, password:)
    @path = path
    @connection_string = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=#{path};Jet OLEDB:Database Password=#{password}"
    @connection = WIN32OLE.new('ADODB.Connection')
  end

  def open
    connection.Open(connection_string)
  end

  def query(sql)
    rows = []
    fields = []

    recordset = WIN32OLE.new('ADODB.Recordset')
    recordset.Open(sql, connection)

    recordset.Fields.each do |field|
      fields << field.Name
    end

    begin
      rows = recordset.GetRows.transpose
    rescue StandardError
      rows = []
    end

    recordset.Close

    rows
  end

  def execute(sql)
    connection.Execute(sql)
  end

  def close
    connection.Close
  end
end
