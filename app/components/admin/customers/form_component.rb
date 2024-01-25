# frozen_string_literal: true

class Admin::Customers::FormComponent < ApplicationComponent
  def initialize(customer:)
      @customer = customer
    end

    attr_reader :customer
end
