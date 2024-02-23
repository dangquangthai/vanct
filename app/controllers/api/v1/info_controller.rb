# frozen_string_literal: true

module API
  module V1
    class InfoController < API::V1::BaseController
      before_action :require_customer!

      def index
        json_response({ live: @customer.live?, sync: @customer.sync? })
      end
    end
  end
end
