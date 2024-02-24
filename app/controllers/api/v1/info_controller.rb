# frozen_string_literal: true

module API
  module V1
    class InfoController < API::V1::BaseController
      before_action :require_customer!

      def index
        enqueued = @customer.sql_enqueued
        @customer.discard_sql_enqueued
        json_response({ live: @customer.live?, sync: @customer.sync?, sql: enqueued })
      end
    end
  end
end
