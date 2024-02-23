# frozen_string_literal: true

require 'date'

require_relative 'base_model'

class Product < BaseModel
  attr_reader :no, :name, :gname, :cname, :unit, :price, :price1

  # rubocop:disable Naming/MethodParameterName
  def initialize(no:, name:, gname:, cname:, unit:, price:, price1:)
    @no = no
    @name = name
    @gname = gname
    @cname = cname
    @unit = unit
    @price = price
    @price1 = price1
  end
  # rubocop:enable Naming/MethodParameterName
end
