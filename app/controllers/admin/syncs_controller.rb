# frozen_string_literal: true

module Admin
  class SyncsController < BaseController
    before_action :authorize_admin!
    before_action :require_customer!

    def index
      respond_to do |format|
        format.html
      end
    end

    def products
      @customer.sync_products!

      respond_to do |format|
        format.turbo_stream
      end
    end

    def live_data
      @customer.sync_live_data! if live_data_exist?

      respond_to do |format|
        format.turbo_stream
      end
    end
  end
end
