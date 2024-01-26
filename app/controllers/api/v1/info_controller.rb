# frozen_string_literal: true

module API
  module V1
    class InfoController < API::V1::BaseController
      before_action :require_customer!

      def show
        json_response({ success: true })
      end
    end
  end
end
