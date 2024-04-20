# frozen_string_literal: true

module API
  module V1
    class SyncProductsController < API::V1::BaseController
      before_action :require_customer!

      def create
        ActiveRecord::Base.transaction do
          products_params.each do |product_params|
            product = @customer.products.find_by(no: product_params[:no])

            if product.present?
              product.update!(product_params)
            else
              @customer.products.create!(product_params)
            end
          end
        end

        json_response({ success: true })
      end

      def products_params
        @products_params ||= params.permit(products: %i[
                                             no
                                             name
                                             gname
                                             cname
                                             unit
                                             price
                                             price1
                                           ]).to_h[:products]
      end
    end
  end
end
