# frozen_string_literal: true

module Shared
  class SortColumnComponent < ApplicationComponent
    def initialize(column:, title:, **options)
      @column = column
      @title = title
      @options = options
    end

    attr_reader :column, :title, :options
  end
end
