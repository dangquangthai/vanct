# frozen_string_literal: true

module Report
  class InventoriesTableComponent < ApplicationComponent
    def initialize(inventories:, pagy:)
      @inventories = inventories
      @pagy = pagy
    end

    attr_reader :inventories, :pagy
  end
end
