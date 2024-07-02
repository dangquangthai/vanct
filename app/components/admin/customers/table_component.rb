# frozen_string_literal: true

module Admin
  module Customers
    class TableComponent < ApplicationComponent
      def initialize(customers:, pagy:)
        @customers = customers
        @pagy = pagy
      end

      attr_reader :customers, :pagy
    end
  end
end
