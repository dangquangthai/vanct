# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :validate_customer_expired!
  before_action :require_live_data

  def index
    current_customer.update_last_see_at!

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @table = @live_data['tables'].find { |t| t['table_no'] == params.require(:table_no) }

    respond_to do |format|
      format.turbo_stream
    end
  end

  protected

  def require_live_data
    key = "live_data_#{current_customer.key}"
    @live_data = Cache.exist?(key) ? JSON.parse(Cache.read(key)) : {}
  end
end
