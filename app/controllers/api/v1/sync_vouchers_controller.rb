# frozen_string_literal: true

module API
  module V1
    class SyncVouchersController < ApplicationController
      before_action :require_customer!

      def create
        shift = @customer.shifts.find_by(no: shift_no)

        ActiveRecord::Base.transaction do
          vouchers.each do |voucher|
            shift.vouchers.create!(voucher)
          end
        end
      end

      def shift_no
        params.permit(:shift_no)
      end

      def vouchers
        @vouchers ||= params.permit(vouchers: %i[
                                      no
                                      time
                                      note
                                      total
                                      kind
                                    ]).to_h[:vouchers]
      end
    end
  end
end
