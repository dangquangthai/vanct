# frozen_string_literal: true

require_relative 'base_model'

class Customer < BaseModel
  attr_reader :no, :mst, :ten, :mail, :dc, :dt, :dh, :diem, :pt, :gc
           # MATHE, MAST, HOTEN, EMAIL, DIACHI, DIENTHOAI, DENHAN, DIEM, PHANTRAM, GHICHU
  # rubocop:disable Naming/MethodParameterName
  def initialize(no:, mst:, ten:, mail:, dc:, dt:, dh:, diem:, pt:, gc:)
    @no = no
    @mst = mst
    @ten = ten
    @mail = mail
    @dc = dc
    @dt = dt
    @dh = dh
    @diem = diem
    @pt = pt
    @gc = gc
  end
  # rubocop:enable Naming/MethodParameterName
end
