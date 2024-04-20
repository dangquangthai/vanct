# frozen_string_literal: true

require_relative '../models/table'
require_relative '../models/table_line'
require_relative '../models/shift'
require_relative '../models/shift_line'
require_relative '../models/voucher'
require_relative '../models/product'
require_relative '../models/inventory'
require_relative '../models/setting'
require_relative '../models/purchase'

class DbReader
  def initialize(db:)
    @db = db
  end

  attr_reader :db

  def tables(as_hash: false)
    sql = 'select MABAN, COKHACH, CODOI, INBILL, STT, GIOVAO, GIORA, GIAM, PHUCVU from [DANH MUC BAN] where [DONG] = 0 order by STT;'

    db.query(sql).map do |row|
      model = Table.new(
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

      as_hash ? model.to_hash : model
    end
  end

  def table_lines(as_hash: false)
    sql = 'select SOBAN, MAHG, TENHANG, SOLUONG, DONGIA, DVT, NHOM, DABAO, DateValue(NGAY) + TimeValue(GIO) as NGAYGIO, QUAY, MANV, INCHUA, MAQL, XUAT, LUUBAN from [BAN];'

    db.query(sql).map do |row|
      model = TableLine.new(
        table_no: row[0],
        product_no: row[1],
        product_name: row[2],
        amount: row[3],
        price: row[4],
        unit: row[5],
        product_group: row[6],
        da_bao: row[7],
        order_time: row[8],
        cabin: row[9], # QUAY
        staff: row[10], # MANV
        inor: row[11], # INCHUA
        no: row[12], # MAQL
        stt: row[13], # XUAT
        bno: row[14] # LUUBAN
      )

      as_hash ? model.to_hash : model
    end
  end

  def shifts(as_hash: false)
    sql = 'select MAKETSO from [DA KET SO] where DADONGBO=false;'

    db.query(sql).map do |row|
      model = Shift.new_from_no(number: row[0])

      as_hash ? model.to_hash : model
    end
  end

  def current_shift
    sql = 'select sum(SOLUONG*DONGIA) as TOTAL, XUAT from [BAN] where SOBAN is null group by XUAT;'

    db.query(sql).map do |row|
      Shift.new(total: row[0], stt: row[1])
    end.first || Shift.new(total: 0, stt: '1')
  end

  def shift_lines(shift, as_hash: false)
    sql = "select MAHG, TENHANG, NHOM, SOLUONG, DONGIA, DVT, LUUBAN, GIAGOC from [LUU KET QUA BAN HANG] where CA=\"#{shift.stt}\" and Val(Format (NGAY, \"yyyymmdd\"))=\"#{shift.date_to_query}\";"

    db.query(sql).map do |row|
      model = ShiftLine.new(
        shift_no: shift.no,
        product_no: row[0],
        product_name: row[1],
        product_group: row[2],
        amount: row[3],
        price: row[4],
        unit: row[5],
        bill_ref: row[6], # LUUBAN
        discount: row[7] # GIAGOC
      )

      as_hash ? model.to_hash : model
    end
  end

  def vouchers(shift, as_hash: false)
    sql = "select SOPHIEU, DateValue(NGAY) + TimeValue(GIO) as NGAYGIO, DIENGIAI, SOTIEN, MATC from [THU CHI] where CA=\"#{shift.stt}\" and Val(Format (NGAY, \"yyyymmdd\"))=\"#{shift.date_to_query}\";"

    db.query(sql).map do |row|
      model = Voucher.new(
        shift_no: shift.no,
        no: row[0],
        time: row[1],
        note: row[2],
        total: row[3],
        kind: row[4] == 'C' ? 'payment' : 'receipt'
      )

      as_hash ? model.to_hash : model
    end
  end

  def products(as_hash: false)
    sql = 'select MAHG, TENHANG, NHOM, MUC, DVT, DONGIA, DONGIA1 from [DANH MUC HANG];'

    db.query(sql).map do |row|
      model = Product.new(
        no: row[0],
        name: row[1],
        gname: row[2], # NHOM
        cname: row[3], # MUC
        unit: row[4], # DVT
        price: row[5], # DONGIA
        price1: row[6] # DONGIA1
      )

      as_hash ? model.to_hash : model
    end
  end

  def inventories(as_hash: false)
    sql = 'select MAHG, TENHANG, DVT, TONDAU, NHAP, XUAT, TONCUOI from [DANH MUC MUA];'

    db.query(sql).map do |row|
      model = Inventory.new(
        no: row[0], # MAHG
        name: row[1], # TENHANG
        unit: row[2], # DVT
        open: row[3], # TONDAU
        input: row[4], # NHAP
        output: row[5], # XUAT
        close: row[6] # TONCUOI
      )

      as_hash ? model.to_hash : model
    end
  end

  def settings(as_hash: false)
    keys = %w[MATKHAU NOIDUNG GIAM SUA IN GIATET]
    sql = "select #{keys.map { |k| "`#{k}`" }.join(', ')} from [TUY CHON];" # always return 1 row
    row = db.query(sql)[0]

    keys.each_with_index.map do |key, index|
      value = if row[index].is_a?(FalseClass)
                '0'
              elsif row[index].is_a?(TrueClass)
                '1'
              else
                row[index]
              end

      model = Setting.new(name: key, value: value)

      as_hash ? model.to_hash : model
    end
  end

  def purchases(shift, as_hash: false)
    sql = "select (SOPHIEU & '-' & CA & '-' & FORMAT(NGAY, 'yyyy') & '-' & FORMAT(NGAY, 'mm') & '-' & FORMAT(NGAY, 'dd')) as PHIEU, DateValue(NGAY) + TimeValue(GIO) as NGAYGIO, NHACUNGCAP, DIENTHOAI, MAHG, TENHANG, NHOM, DONGIA, DVT, SOLUONG, (DONGIA*SOLUONG) as TONG from [CHI TIET NHAP HANG] where DADONGBO=false and CA=\"#{shift.stt}\" and Val(Format (NGAY, \"yyyymmdd\"))=\"#{shift.date_to_query}\";"

    db.query(sql).map do |row|
      model = Purchase.new(
        no: row[0], # PHIEU
        time: row[1],
        ncc: row[2], # NHACUNGCAP
        sdt: row[3], # DIENTHOAI
        pno: row[4],
        name: row[5],
        gname: row[6],
        price: row[7],
        unit: row[8],
        sl: row[9], # SOLUONG
        tt: row[10] # TONG
      )

      as_hash ? model.to_hash : model
    end
  end
end
