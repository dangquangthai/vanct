# frozen_string_literal: true

module API
  module V1
    class LiveController < API::V1::BaseController
      before_action :require_customer!

      def create
        json_response({ success: true })
      end
    end
  end
end
