# frozen_string_literal: true

module API
  module V1
    class SyncProductsController < API::V1::BaseController
      before_action :require_customer!

      def create
        products.each do |product|
          @customer.products.create!(product)
        end
      end

      def products
        @products ||= params.permit(products: %i[
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
