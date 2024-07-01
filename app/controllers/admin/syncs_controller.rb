# frozen_string_literal: true

module Admin
  class SyncsController < BaseController
    before_action :authorize_admin!
    before_action :require_tenant!

    def index
      respond_to do |format|
        format.html
      end
    end

    def products
      @tenant.sync_products!
      flash[:notice] = 'Đã sẳn sàng đồng bộ danh mục Món'

      respond_to do |format|
        format.turbo_stream
      end
    end

    def live_data
      @tenant.sync_live_data! if @tenant.live_data_exist?
      flash[:notice] = 'Đã sẳn sàng đồng bộ dữ liệu Hiện tại (bán online)'

      respond_to do |format|
        format.turbo_stream
      end
    end
  end
end
