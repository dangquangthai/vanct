# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  delegate :current_user, to: Current

  include ApplicationHelper

  def show_money(number)
    number_to_currency(number, precision: 0, unit: 'đ', format: '%n %u')
  end

  def show_time_ago(time)
    time = Time.zone.parse(time) if time.is_a?(String)
    time = Time.zone.parse("#{Time.zone.today.strftime('%Y-%m-%d')} #{time.strftime('%H:%M:%S')}")

    total_minute = ((Time.current - time) / 1.minute).round
    hours = total_minute / 60
    minutes = total_minute % 60

    "#{hours}h #{minutes}m"
  end

  def in_time_humanize(time)
    return if time.blank?

    time = Time.zone.parse(time) if time.is_a?(String)
    time.strftime('%H:%M')
  end
end
