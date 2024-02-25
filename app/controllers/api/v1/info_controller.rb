# frozen_string_literal: true

module API
  module V1
    class InfoController < API::V1::BaseController
      before_action :require_customer!

      def index
        json_response({ live: @customer.live?, sync: @customer.sync?, sql: sql_enqueued })
      end

      protected

      def sql_enqueued
        return [] unless @customer.sync?

        enqueued = @customer.sql_enqueued
        @customer.discard_sql_enqueued
        enqueued
      end
    end
  end
end
