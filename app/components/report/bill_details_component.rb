# frozen_string_literal: true

module Report
  class BillDetailsComponent < ApplicationComponent
    def initialize(bill:)
      @bill = bill
    end

    attr_reader :bill
  end
end
