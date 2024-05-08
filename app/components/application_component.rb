# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  delegate :current_user, :current_customer, to: Current

  include ApplicationHelper
end
