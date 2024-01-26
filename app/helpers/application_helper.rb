# frozen_string_literal: true

module ApplicationHelper
  include Turbo::StreamsHelper

  def svg_icon(filename, **options)
    fullpath = Rails.root.join('app', 'assets', 'images', 'svg', "#{filename}.svg")
    return unless File.exist?(fullpath)

    file = File.read(fullpath)
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    options.each { |attr, value| svg[attr.to_s] = value }
    doc.to_html
  end

  def turbo_modal
    turbo_stream.update('turbo-modal') do
      content_tag :div, data: { controller: 'turbo-modal' }, class: 'w-full md:w-[450px] p-4 mx-4 md:mx-0 bg-white rounded-md' do
        yield
      end
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
    @table_params ||= params.permit(:sc, :sd, :pn, :ps, q: {}).to_h.deep_symbolize_keys
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

  def page_number
    table_params[:pn] || 1
  end

  def page_size
    table_params[:ps] || 100
  end
end
