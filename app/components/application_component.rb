# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  delegate :current_user, :current_tenant, to: Current

  include ApplicationHelper
end
