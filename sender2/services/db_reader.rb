# frozen_string_literal: true

require_relative '../models/table'
require_relative '../models/table_line'
require_relative '../models/shift'
require_relative '../models/shift_line'

class DbReader
  def initialize(db:)
    @db = db
  end

  attr_reader :db

  def tables
    sql = 'select MABAN, COKHACH, CODOI, INBILL, STT, GIOVAO, GIORA, GIAM, PHUCVU from [DANH MUC BAN] where [DONG] = 0 order by STT;'

    db.query(sql).map do |row|
      Table.new(
        table_no: row[0],
        busy: row[1],
        has_change: row[2],
        printed: row[3],
        stt: row[4],
        in_time: row[5],
        out_time: row[6],
        discount: row[7],
        staff: row[8]
      )
    end
  end

  def table_lines
    sql = 'select SOBAN, MAHG, TENHANG, SOLUONG, DONGIA, DVT, NHOM, DABAO, DateValue(NGAY) + TimeValue(GIO) as NGAYGIO from [BAN];'

    db.query(sql).map do |row|
      TableLine.new(
        table_no: row[0],
        product_no: row[1],
        product_name: row[2],
        amount: row[3],
        price: row[4],
        unit: row[5],
        product_group: row[6],
        da_bao: row[7],
        order_time: row[8]
      )
    end
  end

  def shifts
    sql = 'select MAKETSO from [DA KET SO] where DADONGBO=false;'

    db.query(sql).map do |row|
      Shift.new_from_name(name: row[0])
    end
  end

  def current_shift
    sql = 'select sum(SOLUONG*DONGIA) as TOTAL, XUAT from [BAN] where SOBAN is null group by XUAT;'

    db.query(sql).map do |row|
      Shift.new(total: row[0], stt: row[1])
    end.first
  end

  def shift_lines(shift)
    sql = "select MAHG, TENHANG, NHOM, SOLUONG, DONGIA, DVT, LUUBAN from [LUU KET QUA BAN HANG] where CA=\"#{shift.stt}\" and Val(Format (NGAY, \"yyyymmdd\"))=\"#{shift.date.strftime('%Y%m%d')}\";"

    db.query(sql).map do |row|
      ShiftLine.new(
        product_no: row[0],
        product_name: row[1],
        product_group: row[2],
        amount: row[3],
        price: row[4],
        unit: row[5],
        bill_no: row[6]
      )
    end
  end
end
