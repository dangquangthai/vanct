# frozen_string_literal: true

module Admin
  class CustomersController < BaseController
    before_action :authorize_admin!

    def index
      @customers = Customer.without_ace

      respond_to do |format|
        format.html
      end
    end

    def new
      @customer = Customer.new

      respond_to do |format|
        format.turbo_stream
      end
    end

    def create
      @customer = Customer.create(customer_params)

      respond_to do |format|
        format.turbo_stream do
          if @customer.persisted?
            @customer.init_settings
            @customer.queue_update_settings_to_desktop
          end
        end
      end
    end

    def edit
      @customer = Customer.find(params[:id])

      respond_to do |format|
        format.turbo_stream
      end
    end

    def update
      @customer = Customer.find(params[:id])

      respond_to do |format|
        format.turbo_stream do
          @success = @customer.update(customer_params)
          @customer.queue_update_settings_to_desktop if @success
        end
      end
    end

    def destroy
      @customer = Customer.find(params[:id])

      respond_to do |format|
        format.turbo_stream do
          @customer.destroy
        end
      end
    end

    protected

    def customer_params
      params.require(:customer).permit(:name, :key, :expires_at, :enabled, :sync_data)
    end
  end
end
