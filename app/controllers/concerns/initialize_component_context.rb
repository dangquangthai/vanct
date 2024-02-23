# frozen_string_literal: true

module InitializeComponentContext
  extend ActiveSupport::Concern

  included do
    before_action :initialize_component_context

    def initialize_component_context
      return unless user_signed_in?

      Current.current_user = current_user
      Current.current_customer = current_user.customer
    end
  end
end
