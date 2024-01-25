class Admin::UsersController < ApplicationController
  before_action :authorize_admin!
  before_action :require_customer!

  def index
    @users = @customer.users

    respond_to do |format|
      format.html
    end
  end

  protected

  def require_customer!
    @customer = Customer.find(params[:customer_id])
  end
end
