# frozen_string_literal: true

module API
  module V2
    class InfoController < API::V1::BaseController
      before_action :require_customer!

      def live_data
        json_response({ live: @customer.live?, sql: live_queries })
      end

      def sync_data
        json_response({ sync: @customer.sync?, sql: @customer.queue_update_settings_to_desktop })
      end

      protected

      def live_queries
        return [] unless @customer.sync?

        enqueued = @customer.sql_enqueued
        @customer.discard_sql_enqueued
        enqueued
      end
    end
  end
end
