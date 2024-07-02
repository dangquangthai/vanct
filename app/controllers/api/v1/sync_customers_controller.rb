# frozen_string_literal: true

module API
  module V1
    class SyncCustomersController < ApplicationController
      before_action :require_tenant!

      def create
        ActiveRecord::Base.transaction do
          customers_params.each do |customer_params|
            customer = @tenant.customers.find_by(no: customer_params[:no])

            new_params = {
              no: customer_params[:no],
              tax_code: customer_params[:mst],
              legal_name: customer_params[:ten],
              emai: customer_params[:mail],
              address: customer_params[:dc],
              phone_number: customer_params[:dt],
              expired_at: customer_params[:dh],
              point: customer_params[:diem],
              percentage: customer_params[:pt],
              note: customer_params[:gc]
            }

            if customer.present?
              customer.update!(new_params)
            else
              @tenant.customers.create!(new_params)
            end
          end
        end

        json_response({ success: true })
      end

      private

      def customers_params
        @customers_params ||= params.permit(customers: %i[
                                              no
                                              mst
                                              ten
                                              mail
                                              dc
                                              dt
                                              dh
                                              diem
                                              pt
                                              gc
                                            ]).to_h[:customers]
      end
    end
  end
end
