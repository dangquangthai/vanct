# frozen_string_literal: true

module Report
  class PurchaseShowComponent < ApplicationComponent
    def initialize(purchase:)
      @purchase = purchase
    end

    attr_reader :purchase
  end
end
