# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    before_action :authorize_admin!
    before_action :require_customer!

    def index
      @users = @customer.users

      respond_to do |format|
        format.html
      end
    end

    def new
      @user = @customer.users.build

      respond_to do |format|
        format.turbo_stream
      end
    end

    def create
      @user = @customer.users.build(new_user_params)

      respond_to do |format|
        format.turbo_stream { @user.save }
      end
    end

    def edit
      @user = @customer.users.find(params[:id])

      respond_to do |format|
        format.turbo_stream
      end
    end

    def update
      @user = @customer.users.find(params[:id])

      respond_to do |format|
        format.turbo_stream do
          @user.role = edit_user_params[:role]
          @user.password = edit_user_params[:password] if edit_user_params[:password].present?
          @success = @user.save
        end
      end
    end

    def destroy
      @user = @customer.users.find(params[:id])

      respond_to do |format|
        format.turbo_stream do
          @user.destroy!
        end
      end
    end

    protected

    def new_user_params
      params.require(:user).permit(:username, :password, :role)
    end

    def edit_user_params
      @edit_user_params ||= params.require(:user).permit(:password, :role)
    end
  end
end
