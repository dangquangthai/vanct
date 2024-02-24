# frozen_string_literal: true

module Admin
  class ProductsController < ApplicationController
    before_action :authorize_manager!

    def index
      @pagy, @products = pagy(products_query, items: 30)

      respond_to do |format|
        format.html
      end
    end

    def edit
      @product = current_customer.products.find(params[:id])

      respond_to do |format|
        format.turbo_stream
      end
    end

    def update
      @product = current_customer.products.find(params[:id])
      @success = @product.update(update_params)

      respond_to do |format|
        format.turbo_stream do
          if @success
            @product.queue_update_to_desktop
            @pagy, @products = pagy(products_query, items: 30)
          end
        end
      end
    end

    protected

    def update_params
      params.require(:product).permit(:unit, :name, :gname, :cname, :unit, :price, :price1)
    end

    def products_query
      products = current_customer.products
      products = productswhere('LOWER(products.name) LIKE ?', "%#{name.downcase}%") if name.present?
      products.order(:no)
    end

    def name
      helpers.query_attributes[:name]
    end
  end
end
