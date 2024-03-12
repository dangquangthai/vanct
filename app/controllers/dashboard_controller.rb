# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :validate_customer_expired!
  before_action :require_live_data

  def index
    current_customer.delete_live_data_if_expired!
    current_customer.update_last_see_at!

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @table = @live_data['tables'].find { |t| t['uuid'] == params.require(:table_no) }

    respond_to do |format|
      format.turbo_stream
    end
  end

  protected

  def require_live_data
    @live_data = current_customer.live_data_exist? ? current_customer.live_data : {}
  end
end
