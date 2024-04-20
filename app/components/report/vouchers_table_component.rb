# frozen_string_literal: true

module Report
  class VouchersTableComponent < ApplicationComponent
    def initialize(vouchers:, pagy:)
      @vouchers = vouchers
      @pagy = pagy
    end

    attr_reader :vouchers, :pagy

    def kind_classes(purchase)
      class_names('h-5 flex items-center justify-end', 'text-red-600' => voucher.kind == 'payment', 'text-green-700' => voucher.kind == 'receipt')
    end
  end
end
