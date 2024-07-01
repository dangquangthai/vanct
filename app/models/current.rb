# frozen_string_literal: true

# https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html
class Current < ActiveSupport::CurrentAttributes
  attribute :current_user, :current_tenant

  TIME_FORMAT = '%Y-%m-%d %H:%M:%S'

  class << self
    def ftime
      Time.current.strftime(TIME_FORMAT)
    end

    def last_seen_in_minutes?(time_string, value)
      time = Time.strptime(time_string, TIME_FORMAT).in_time_zone
      time >= value.ago
    end
  end
end
