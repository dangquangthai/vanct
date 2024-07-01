# frozen_string_literal: true

module InitializeComponentContext
  extend ActiveSupport::Concern

  included do
    before_action :initialize_component_context

    def initialize_component_context
      return unless user_signed_in?

      Current.current_user = current_user
      Current.current_tenant = current_tenant
    end

    def current_tenant
      current_user.tenant
    end
    helper_method :current_tenant
  end
end
