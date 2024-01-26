# frozen_string_literal: true

module Admin
  class CustomersController < ApplicationController
    def index
      @customers = Customer.all

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
        format.turbo_stream
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