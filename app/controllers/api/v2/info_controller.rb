# frozen_string_literal: true

module API
  module V2
    class InfoController < API::V1::BaseController
      before_action :require_tenant!

      def live_data
        json_response({ live: @tenant.live?, sql: live_queries })
      end

      def sync_data
        json_response({
                        sync: @tenant.sync?,
                        sql: @tenant.queue_update_settings_to_desktop,
                        sync_purchase: @tenant.sync_purchase?,
                        sync_inventory: @tenant.sync_inventory?,
                        sync_voucher: @tenant.sync_voucher?
                      })
      end

      protected

      def live_queries
        return [] unless @tenant.sync?

        enqueued = @tenant.sql_enqueued
        @tenant.discard_sql_enqueued
        enqueued
      end
    end
  end
end
