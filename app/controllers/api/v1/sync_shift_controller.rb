# frozen_string_literal: true

module API
  module V1
    class SyncShiftController < API::V1::BaseController
      before_action :require_customer!

      def create
        success = @customer.shifts.where(no: shift_no).count.zero? && bill_refs.present?

        if success
          ActiveRecord::Base.transaction do
            bill_refs.each do |bill_ref|
              lines = shift_lines.select { |line| line[:bill_ref] == bill_ref }
              new_bill = create_bill(bill_ref, lines)
              create_bill_lines(new_bill, lines)
            end
          end
        end

        json_response({ success: success })
      end

      protected

      def create_bill_lines(new_bill, lines)
        lines.each do |line|
          new_bill.bill_lines.create!(
            product_no: line[:product_no],
            product_name: line[:product_name],
            product_group: line[:product_group],
            amount: line[:amount],
            price: line[:price],
            unit: line[:unit],
            total: line[:amount] * line[:price],
            discount: line[:amount] * (line['discount'] || 0)
          )
        end
      end

      def create_bill(bill_ref, lines)
        refs = bill_ref.split('-')

        new_shift.bills.create!(
          bill_no: refs[1],
          table_no: refs[2],
          total: lines.sum { |line| line[:amount] * line[:price] },
          discount: lines.sum { |line| line[:amount] * (line[:discount] || 0) }
        )
      end

      def bill_refs
        shift_lines.map { |line| line[:bill_ref] }.uniq
      end

      def new_shift
        @new_shift ||= @customer.shifts.create!(
          no: shift_no,
          stt: shift_no.split('-')[0],
          shift_date: Time.zone.parse(shift_no.last(10)),
          total: shift_lines.sum { |line| line[:amount] * line[:price] }
        )
      end

      def bill_ref
        @bill_ref ||= shift_lines.first[:bill_ref]
      end

      def shift_no
        @shift_no ||= shift_lines.first[:shift_no]
      end

      def shift_lines
        @shift_lines ||= params.permit(shift_lines: %i[
                                         shift_no
                                         product_no
                                         product_name
                                         product_group
                                         amount
                                         price
                                         unit
                                         bill_ref
                                         discount
                                       ]).to_h[:shift_lines]
      end
    end
  end
end
