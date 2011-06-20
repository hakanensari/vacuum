require 'sucker'
require 'em-synchrony'
require 'em-synchrony/em-http'

module Sucker
  class Request
    def adapter
      @adapter ||= EM::HttpRequest
    end

    def get
      http = EM::HttpRequest.new(url).get
      Response.new(http)
    end
  end

  class Response
    def initialize(http)
      self.body = http.response
      self.code = http.response_header.status
    end
  end
end
