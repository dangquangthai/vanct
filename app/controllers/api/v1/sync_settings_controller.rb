# frozen_string_literal: true

module API
  module V1
    class SyncSettingsController < API::V1::BaseController
      before_action :require_tenant!

      def create
        ActiveRecord::Base.transaction do
          settings_params.each do |setting_params|
            setting = @tenant.settings.find_by(name: setting_params[:name])

            setting.update!(value: setting_params[:value]) if setting.present?
          end
        end

        json_response({ success: true })
      end

      def settings_params
        @settings_params ||= params.permit(settings: %i[
                                             name
                                             value
                                           ]).to_h[:settings]
      end
    end
  end
end
