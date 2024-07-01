# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    def require_tenant!
      @tenant = Tenant.find(params[:tenant_id])
    end
  end
end
