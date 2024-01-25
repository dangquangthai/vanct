# frozen_string_literal: true

module Admin
  class CustomersController < ApplicationController
    def index
      @customers = Customer.all

      respond_to do |format|
        format.html
      end
    end
  end
end
