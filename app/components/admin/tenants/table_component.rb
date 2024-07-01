# frozen_string_literal: true

module Admin
  module Tenants
    class TableComponent < ApplicationComponent
      def initialize(tenants:)
        @tenants = tenants
      end

      attr_reader :tenants
    end
  end
end
