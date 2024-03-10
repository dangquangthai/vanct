# frozen_string_literal: true

module API
  module V1
    class SyncSettingsController < ApplicationController
      before_action :require_customer!

      def create
        ActiveRecord::Base.transaction do
          settings_params.each do |setting_params|
            setting = @customer.settings.find_by(name: setting_params[:name])

            setting.update!(setting_params[:value]) if setting.present?
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
