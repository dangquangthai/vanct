require 'uri'
require 'json'
require 'net/http'

class ApiClient
  def initialize(key:, endpoint:)
    @key = key
    @endpoint = endpoint
  end

  def info
    uri = URI.parse("#{endpoint}/api/v1/info?key=#{key}")
    ssl = uri.scheme == 'https'
    request = Net::HTTP::Get.new(uri.to_s)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: ssl) { |http| http.request(request) }
    JSON.parse(response.body)
  end

  def live(data)
    post(data, 'live')
  end

  def sync_shift(data)
    post(data, 'sync_shift')
  end

  private

  attr_reader :endpoint, :key

  def post(data, method)
    uri = URI.parse("#{endpoint}/api/v1/#{method}?key=#{key}")
    ssl = uri.scheme == 'https'
    request = Net::HTTP::Post.new(uri.to_s, { 'Content-Type' => 'application/json' })
    request.body = data.to_json 
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: ssl) { |http| http.request(request) }
    JSON.parse(response.body)
  end
end
