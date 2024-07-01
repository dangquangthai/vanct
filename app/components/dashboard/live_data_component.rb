# frozen_string_literal: true

module Dashboard
  class LiveDataComponent < ApplicationComponent
    def initialize(live_data:)
      @live_data = live_data
      @shift = live_data['shift']
      @tables = live_data['tables']
    end

    attr_reader :live_data, :shift, :tables

    def render?
      live_data['shift'].present? && live_data['tables'].present?
    end

    def busy_tables
      @busy_tables ||= tables.select { |table| table['busy'] }
    end

    def da_bao_tables
      tables.select { |table| table['da_bao'] }
    end

    def busy_tables_sum
      busy_tables.sum { |table| table['total'] || 0 }
    end

    def build_table_css(table)
      class_names('rounded border h-20 grid px-2 py-1 relative',
                  'bg-green-800 text-white': table['busy'] && table['printed'],
                  'bg-red-600 text-white': table['busy'] && !table['printed'])
    end
  end
end
