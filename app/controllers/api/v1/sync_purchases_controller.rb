# frozen_string_literal: true

module API
  module V1
    class SyncPurchasesController < API::V1::BaseController
      before_action :require_customer!

      def create
        shift = @customer.shifts.find_by(no: params[:shift_no])

        ActiveRecord::Base.transaction do
          purchase_numbers.each do |purchase_number|
            lines = purchase_lines(purchase_number)
            first_line = lines.first

            new_purchase = shift.purchases.create!(
              no: purchase_number,
              total: sum_purchase(purchase_number),
              provider_name: first_line['ncc'],
              phone_number: first_line['sdt'],
              time: first_line['time']
            )

            create_purchase_lines(lines, new_purchase)
          end
        end

        json_response({ success: true })
      end

      protected

      def create_purchase_lines(lines, new_purchase)
        lines.each do |purchase_param|
          new_purchase.purchase_lines.create!(
            time: purchase_param['time'],
            product_no: purchase_param['pno'],
            product_name: purchase_param['name'],
            product_group: purchase_param['gname'],
            amount: purchase_param['sl'],
            price: purchase_param['price'],
            unit: purchase_param['unit'],
            total: purchase_param['tt']
          )
        end
      end

      def purchase_lines(purchase_number)
        purchases_params.select { |i| i['no'] == purchase_number }.sort_by { |i| i['time'] }
      end

      def sum_purchase(purchase_number)
        purchases_params.select { |i| i['no'] == purchase_number }.sum { |i| i['tt'] || 0 }
      end

      def purchase_numbers
        purchases_params.map { |purchase_param| purchase_param['no'] }.uniq
      end

      def purchases_params
        @purchases_params ||= params.permit(purchases: %i[
                                              no
                                              time
                                              ncc
                                              sdt
                                              pno
                                              name
                                              gname
                                              price
                                              unit
                                              sl
                                              tt
                                            ]).to_h[:purchases]
      end
    end
  end
end
