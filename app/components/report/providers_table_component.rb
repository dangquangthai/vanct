# frozen_string_literal: true

module Report
  class ProvidersTableComponent < ApplicationComponent
    def initialize(providers:, pagy:)
      @providers = providers
      @pagy = pagy
    end

    attr_reader :providers, :pagy
  end
end
