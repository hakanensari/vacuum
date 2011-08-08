require 'amazon_product'
require 'em-synchrony'
require 'em-synchrony/em-http'

# Patches Request and Response to make them fiber-aware.
module AmazonProduct
  class Request
    def adapter
      @adapter ||= EM::HttpRequest
    end

    # Performs an evented request.
    #
    # Yields a response to given block.
    def aget(&block)
      http = EM::HttpRequest.new(url).aget
      http.callback { block.call(Response.new(http)) }
      http.errback  { block.call(Response.new(http)) }
    end

    # Performs an evented request.
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
