# frozen_string_literal: true

module Admin
  module Customers
    class FormComponent < ApplicationComponent
      def initialize(customer:)
        @customer = customer
      end

      attr_reader :customer
    end
  end
end
