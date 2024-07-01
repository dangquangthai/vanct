# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  include InitializeComponentContext
  include Pagy::Backend

  protected

  def validate_tenant_expired!
    redirect_to expired_path if current_tenant.expired?
  end

  def validate_tenant_sync_data!
    redirect_to root_path unless current_tenant.sync_data?
  end

  def authorize_admin!
    redirect_to root_path, alert: 'Access Denied' unless current_user.admin?
  end

  def authorize_manager!
    redirect_to root_path, alert: 'Access Denied' unless current_user.manager?
  end
end
