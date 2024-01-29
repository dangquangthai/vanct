# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  include InitializeComponentContext
  include Pagy::Backend

  protected

  def authorize_admin!
    redirect_to root_path, alert: 'Access Denied' unless current_user.admin?
  end
end
