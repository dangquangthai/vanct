# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  include InitializeComponentContext
  include Pagy::Backend

  protected

  def validate_customer_expired!
    redirect_to expired_path if current_customer.expired?
  end

  def authorize_admin!
    redirect_to root_path, alert: 'Access Denied' unless current_user.admin?
  end

  def authorize_manager!
    redirect_to root_path, alert: 'Access Denied' unless current_user.manager?
  end
end
