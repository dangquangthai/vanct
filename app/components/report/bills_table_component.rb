# frozen_string_literal: true

module Report
  class BillsTableComponent < ApplicationComponent
    def initialize(bills:, pagy:)
      @bills = bills
      @pagy = pagy
    end

    attr_reader :bills, :pagy
  end
end
