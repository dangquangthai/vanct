# frozen_string_literal: true

module Admin
  class ProductsController < BaseController
    before_action :authorize_manager!

    def index
      @pagy, @products = pagy(products_query, items: 30)

      respond_to do |format|
        format.html
      end
    end

    def new
      @product = current_tenant.products.build

      respond_to do |format|
        format.turbo_stream
      end
    end

    def create
      @product = current_tenant.products.build(create_params)
      @product.have_to_validate = true
      @success = @product.valid? && @product.save

      respond_to do |format|
        format.turbo_stream do
          if @success
            flash[:notice] = 'Thêm món thành công!'
            @product.queue_insert_to_desktop
          end
        end
      end
    end

    def edit
      @product = current_tenant.products.find(params[:id])

      respond_to do |format|
        format.turbo_stream
      end
    end

    def update
      @product = current_tenant.products.find(params[:id])
      @product.assign_attributes(update_params)
      @product.have_to_validate = true
      @success = @product.valid? && @product.save

      respond_to do |format|
        format.turbo_stream do
          if @success
            flash[:notice] = 'Cập nhật món thành công!'
            @product.queue_update_to_desktop
          end
        end
      end
    end

    protected

    def create_params
      params.require(:product).permit(:no, :unit, :name, :gname, :cname, :unit, :price, :price1)
    end

    def update_params
      params.require(:product).permit(:unit, :name, :gname, :cname, :unit, :price, :price1)
    end

    def products_query
      products = current_tenant.products
      products = products.where('LOWER(products.name) LIKE ?', "%#{name.downcase}%") if name.present?
      products.order(:no)
    end

    def name
      helpers.query_attributes[:name]
    end
  end
end
