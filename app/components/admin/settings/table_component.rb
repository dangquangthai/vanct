# frozen_string_literal: true

module Admin
  module Settings
    class TableComponent < ApplicationComponent
      def initialize(settings:, customer:)
        @settings = settings
        @customer = customer
      end

      attr_reader :settings, :customer
    end
  end
end
