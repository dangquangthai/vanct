# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  delegate :current_user, to: Current

  include ApplicationHelper
  include TimeHelper
end
