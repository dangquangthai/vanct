# frozen_string_literal: true

class CurrentUserController < ApplicationController
  def show
    respond_to do |format|
      format.turbo_stream
    end
  end

  def change_password
    new_password = params.require(:user).permit(:new_password)[:new_password]
    current_user.update!(password: new_password)

    respond_to do |format|
      format.turbo_stream
    end
  end
end
