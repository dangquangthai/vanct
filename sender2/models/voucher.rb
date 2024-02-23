# frozen_string_literal: true

require 'date'

require_relative 'base_model'

class Voucher < BaseModel
  attr_reader :shift_no, :no, :time, :description, :total, :type

  def initialize(shift_no:, no:, time:, description:, total:, type:)
    @shift_no = shift_no
    @no = no
    @time = time
    @description = description
    @total = total
    @type = type
  end
end
