# frozen_string_literal: true

module Admin
  class TenantsController < BaseController
    before_action :authorize_admin!

    def index
      @tenants = Tenant.without_ace.order('created_at DESC')

      respond_to do |format|
        format.html
      end
    end

    def new
      @tenant = Tenant.new

      respond_to do |format|
        format.turbo_stream
      end
    end

    def create
      @tenant = Tenant.create(tenant_params)

      respond_to do |format|
        format.turbo_stream do
          @tenant.init_settings if @tenant.persisted?
        end
      end
    end

    def edit
      @tenant = Tenant.find(params[:id])

      respond_to do |format|
        format.turbo_stream
      end
    end

    def update
      @tenant = Tenant.find(params[:id])

      respond_to do |format|
        format.turbo_stream do
          @success = @tenant.update(tenant_params)
        end
      end
    end

    def destroy
      @tenant = Tenant.find(params[:id])

      respond_to do |format|
        format.turbo_stream do
          @tenant.destroy
        end
      end
    end

    protected

    def tenant_params
      params.require(:tenant).permit(:name, :key, :expires_at, :enabled, :sync_data, :sync_purchase, :sync_inventory, :sync_voucher, :tax_code, :tax_vat_value, :tax_vat_inclusion)
    end
  end
end
