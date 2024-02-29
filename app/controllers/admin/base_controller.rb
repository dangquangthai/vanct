# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    def require_customer!
      @customer = Customer.find(params[:customer_id])
    end
  end
end
