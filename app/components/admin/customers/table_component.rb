# frozen_string_literal: true

module Admin
  module Customers
    class TableComponent < ApplicationComponent
      def initialize(customers:)
        @customers = customers
      end

      attr_reader :customers
    end
  end
end
