# frozen_string_literal: true

module Report
  class PurchasesTableComponent < ApplicationComponent
    def initialize(purchases:, pagy:)
      @purchases = purchases
      @pagy = pagy
    end

    attr_reader :purchases, :pagy
  end
end
