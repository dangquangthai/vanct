# frozen_string_literal: true

class ExpiredController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @expired_at = current_user.customer.expires_at.strftime('%d/%m/%Y')
  end
end
