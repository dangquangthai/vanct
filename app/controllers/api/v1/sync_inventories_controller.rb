# frozen_string_literal: true

module API
  module V1
    class SyncInventoriesController < API::V1::BaseController
      before_action :require_tenant!

      def create
        latest_shift = @tenant.shifts.last

        if latest_shift.blank?
          json_response({ success: false })
        else
          ActiveRecord::Base.transaction do
            inventories.each do |inventory_params|
              latest_shift.inventories.create!(inventory_params)
            end
          end

          json_response({ success: true })
        end
      end

      def inventories
        @inventories ||= params.permit(inventories: %i[
                                         no
                                         name
                                         unit
                                         open
                                         input
                                         output
                                         close
                                       ]).to_h[:inventories]
      end
    end
  end
end
