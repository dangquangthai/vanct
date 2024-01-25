# frozen_string_literal: true

module TimeHelper
  def time_humanize(time)
    return if time.blank?

    time.strftime('%b %d, %Y %H:%M')
  end
end
