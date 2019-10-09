# frozen_string_literal: true

require 'net/http'
require 'uri'

module Vacuum
  class Adapter
    def self.post(url:, body:, headers:)
      uri = URI.parse(url)
      request = Net::HTTP::Post.new(uri)
      request.content_type = 'application/json; charset=UTF-8'
      headers.each { |k, v| request[k] = v }
      request.body = body
      req_options = { use_ssl: uri.scheme == 'https' }

      Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
    end
  end
end
