# frozen_string_literal: true

module Admin
  class SettingsController < BaseController
    before_action :authorize_admin!
    before_action :require_customer!

    def index
      @customer.init_settings if @customer.settings.count.zero?

      respond_to do |format|
        format.html
      end
    end

    def edit
      @setting = @customer.settings.find(params[:id])

      respond_to do |format|
        format.turbo_stream
      end
    end

    def update
      @setting = @customer.settings.find(params[:id])
      @success = @setting.update(update_params)

      respond_to do |format|
        format.turbo_stream do
          @setting.queue_update_to_desktop if @success
        end
      end
    end

    protected

    def update_params
      params.require(:setting).permit(:name, :value)
    end
  end
end
