# frozen_string_literal: true

module ApplicationHelper
  include Turbo::StreamsHelper

  def turbo_redirect(url)
    turbo_stream.replace('turbo-redirect') do
      content_tag :div, nil, data: { controller: 'turbo--redirect-to', url: }
    end
  end

  def svg_icon(filename, **options)
    fullpath = Rails.root.join('app', 'assets', 'images', 'svg', "#{filename}.svg")
    return unless File.exist?(fullpath)

    file = File.read(fullpath)
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    options.each { |attr, value| svg[attr.to_s] = value }
    doc.to_html
  end
end
