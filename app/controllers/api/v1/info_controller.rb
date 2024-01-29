# frozen_string_literal: true

module API
  module V1
    class InfoController < API::V1::BaseController
      before_action :require_customer!

      def show
        sccuess = !@customer.expired? && @customer.enabled?

        json_response({ success: sccuess })
      end
    end
  end
end
