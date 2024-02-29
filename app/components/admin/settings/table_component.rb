# frozen_string_literal: true

module Admin
  module Settings
    class TableComponent < ApplicationComponent
      def initialize(settings:)
        @settings = settings
      end

      attr_reader :settings
    end
  end
end
