# frozen_string_literal: true

module Admin
  module Products
    class TableComponent < ApplicationComponent
      def initialize(products:, pagy:)
        @products = products
        @pagy = pagy
      end

      attr_reader :products, :pagy
    end
  end
end
