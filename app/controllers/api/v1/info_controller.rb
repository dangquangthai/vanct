# frozen_string_literal: true

module API
  module V1
    class InfoController < API::V1::BaseController
      before_action :require_tenant!

      def index
        json_response({ live: @tenant.live?, sync: @tenant.sync?, sql: sql_enqueued })
      end

      protected

      def sql_enqueued
        return [] unless @tenant.sync?

        enqueued = @tenant.sql_enqueued
        @tenant.discard_sql_enqueued
        enqueued
      end
    end
  end
end
