# frozen_string_literal: true

require_relative 'base_model'

class Setting < BaseModel
  attr_reader :name, :value

  def initialize(name:, value:)
    @name = name
    @value = value
  end
end
