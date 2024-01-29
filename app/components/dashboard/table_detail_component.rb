# frozen_string_literal: true

module Dashboard
  class TableDetailComponent < ApplicationComponent
    def initialize(table:)
      @table = table
    end

    attr_reader :table
  end
end
