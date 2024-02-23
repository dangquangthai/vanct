# frozen_string_literal: true

module API
  module V1
    class SyncVouchersController < API::V1::BaseController
      before_action :require_customer!

      def create
        shift = @customer.shifts.find_by(no: params[:shift_no])

        ActiveRecord::Base.transaction do
          vouchers.each do |voucher|
            shift.vouchers.create!(voucher)
          end
        end
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
