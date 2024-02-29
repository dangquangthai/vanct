# frozen_string_literal: true

module Report
  class BillLinesTableComponent < ApplicationComponent
    def initialize(lines:, pagy:)
      @lines = lines
      @pagy = pagy
    end

    attr_reader :lines, :pagy
  end
end
