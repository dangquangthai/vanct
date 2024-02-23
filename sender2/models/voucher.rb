# frozen_string_literal: true

require 'date'

require_relative 'base_model'

class Voucher < BaseModel
  attr_reader :shift_no, :no, :time, :note, :total, :kind

  # rubocop:disable Naming/MethodParameterName
  def initialize(shift_no:, no:, time:, note:, total:, kind:)
    @shift_no = shift_no
    @no = no
    @time = time
    @note = note
    @total = total
    @kind = kind
  end
  # rubocop:enable Naming/MethodParameterName
end
