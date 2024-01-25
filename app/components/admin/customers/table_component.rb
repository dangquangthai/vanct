# frozen_string_literal: true

class Admin::Customers::TableComponent < ApplicationComponent
  def initialize(customers:)
      @customers = customers
    end

    attr_reader :customers
end
