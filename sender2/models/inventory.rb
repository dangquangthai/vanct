# frozen_string_literal: true

require_relative 'base_model'

class Inventory < BaseModel
  attr_reader :no, :name, :unit, :open, :input, :output, :close

  # rubocop:disable Naming/MethodParameterName
  def initialize(no:, name:, unit:, open:, input:, output:, close:)
    @no = no
    @name = name
    @unit = unit
    @open = open
    @input = input
    @output = output
    @close = close
  end
  # rubocop:enable Naming/MethodParameterName
end
