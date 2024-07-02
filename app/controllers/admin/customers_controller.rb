# frozen_string_literal: true

module Admin
  class CustomersController < BaseController
    before_action :authorize_manager!

    def index
      @pagy, @customers = pagy(customers_query, items: 30)

      respond_to do |format|
        format.html
      end
    end

    def new
      @customer = current_tenant.customers.build

      respond_to do |format|
        format.turbo_stream
      end
    end

    def create
      @customer = current_tenant.customers.build(create_params)
      @success = @customer.valid? && @customer.save

      respond_to do |format|
        format.turbo_stream do
          if @success
            flash[:notice] = 'Thêm khách hàng thành công!'
            @customer.queue_insert_to_desktop
          end
        end
      end
    end

    def edit
      @customer = current_tenant.customers.find(params[:id])

      respond_to do |format|
        format.turbo_stream
      end
    end

    def update
      @customer = current_tenant.customers.find(params[:id])
      @customer.assign_attributes(update_params)
      @success = @customer.valid? && @customer.save

      respond_to do |format|
        format.turbo_stream do
          if @success
            flash[:notice] = 'Cập nhật khách hàng thành công!'
            @customer.queue_update_to_desktop
          end
        end
      end
    end

    protected

    def create_params
      params.require(:customer).permit(:no, :tax_code, :legal_name, :email, :address, :phone_number, :expired_at, :point, :percentage, :note)
    end

    def update_params
      params.require(:customer).permit(:tax_code, :legal_name, :email, :address, :phone_number, :expired_at, :point, :percentage, :note)
    end

    def customers_query
      customers = current_tenant.customers
      customers = customers.where('LOWER(customers.name) LIKE ?', "%#{name.downcase}%") if name.present?
      customers.order(:no)
    end

    def name
      helpers.query_attributes[:name]
    end
  end
end
