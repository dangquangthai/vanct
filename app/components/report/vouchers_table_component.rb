# frozen_string_literal: true

module Report
  class VouchersTableComponent < ApplicationComponent
    def initialize(vouchers:, pagy:)
      @vouchers = vouchers
      @pagy = pagy
    end

    attr_reader :vouchers, :pagy

    def kind_classes(purchase)
      class_names('text-red-600' => !purchase.paid, 'text-green-700' => purchase.paid)
    end
  end
end
