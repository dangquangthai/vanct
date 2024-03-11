# frozen_string_literal: true

require 'uri'
require 'json'
require 'net/http'

class ApiClient
  def initialize(key:, endpoint:)
    @key = key
    @endpoint = endpoint
  end

  # action can be `live_data` or `sync_data`
  def verify_data(action)
    uri = URI.parse("#{endpoint}/api/v2/info/#{action}?key=#{key}")
    ssl = uri.scheme == 'https'
    request = Net::HTTP::Get.new(uri.to_s)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: ssl) { |http| http.request(request) }
    JSON.parse(response.body)
  end

  def live(data)
    post(data, api_method: 'live')
  end

  def sync_shift(data)
    post(data, api_method: 'sync_shift')
  end

  def sync_vouchers(data)
    post(data, api_method: 'sync_vouchers')
  end

  def sync_products(data)
    post(data, api_method: 'sync_products')
  end

  def sync_settings(data)
    post(data, api_method: 'sync_settings')
  end

  def sync_inventories(data)
    post(data, api_method: 'sync_inventories')
  end

  private

  attr_reader :endpoint, :key

  def post(data, api_method:)
    uri = URI.parse("#{endpoint}/api/v1/#{api_method}?key=#{key}")
    ssl = uri.scheme == 'https'
    request = Net::HTTP::Post.new(uri.to_s, { 'Content-Type' => 'application/json' })
    request.body = data.to_json
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: ssl) { |http| http.request(request) }
    JSON.parse(response.body)
  end
end
