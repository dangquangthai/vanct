# frozen_string_literal: true

module Admin
  class SettingsController < BaseController
    before_action :authorize_manager!

    def index
      @settings = current_customer.settings

      respond_to do |format|
        format.html
      end
    end

    def edit
      @setting = current_customer.settings.find(params[:id])

      respond_to do |format|
        format.turbo_stream
      end
    end

    def update
      @setting = current_customer.settings.find(params[:id])
      @success = @setting.update(update_params)

      respond_to do |format|
        format.turbo_stream do
          if @success
            @setting.queue_update_to_desktop
            @settings = current_customer.settings
          end
        end
      end
    end

    protected

    def update_params
      params.require(:setting).permit(:label, :value)
    end
  end
end
