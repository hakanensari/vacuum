require 'sucker'
require 'em-synchrony'
require 'em-synchrony/em-http'

module Sucker
  # Below, we minimally patch Request and Response to make them fiber-aware.
  class Request
    def adapter
      @adapter ||= EM::HttpRequest
    end

    # Performs an evented request and yields a response to provided block.
    def aget(&block)
      http = EM::HttpRequest.new(url).aget
      http.callback { block.call(Response.new(http)) }
      http.errback  { block.call(Response.new(http)) }
    end

    # Performs an evented request and returns a response.
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
