# frozen_string_literal: true

module ApplicationHelper
  include Turbo::StreamsHelper
  include Pagy::Frontend

  def svg_icon(filename, **options)
    fullpath = Rails.root.join('app', 'assets', 'images', 'svg', "#{filename}.svg")
    return unless File.exist?(fullpath)

    file = File.read(fullpath)
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    options.each { |attr, value| svg[attr.to_s] = value }
    doc.to_html
  end

  def turbo_modal(&block)
    turbo_stream.update('turbo-modal') do
      content_tag :div, data: { controller: 'turbo-modal' }, class: 'w-full md:w-[450px] p-4 mx-4 md:mx-0 bg-white rounded-md', &block
    end
  end

  def turbo_modal_close
    turbo_stream.replace('turbo-modal') do
      content_tag :div, nil, id: 'turbo-modal'
    end
  end

  def turbo_redirect(url)
    turbo_stream.replace('turbo-redirect') do
      content_tag :div, nil, data: { controller: 'turbo-redirect', url: url }
    end
  end

  def turbo_klass(query_selector, css_class, action = :update)
    turbo_stream.append('turbo-klass') do
      content_tag :div, nil, data: { controller: 'turbo-klass', selector: query_selector, action: action, klass: css_class }
    end
  end

  def turbo_event(event_name, data = nil)
    turbo_stream.append('turbo-event') do
      content_tag :div, nil, data: {
        controller: 'turbo-event',
        event_name: event_name,
        detail: data&.to_json
      }.compact
    end
  end

  def table_params
    @table_params ||= params.permit(:sc, :sd, q: {}).to_h.deep_symbolize_keys
  end

  def query_attributes
    table_params.fetch(:q, {})
  end

  def sort_column
    table_params[:sc]
  end

  def sort_direction
    table_params[:sd]
  end

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
