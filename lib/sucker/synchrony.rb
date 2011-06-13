require 'sucker'
require 'em-synchrony'
require 'em-synchrony/em-http'

module Sucker
  ResponseProxy = Struct.new(:body, :code)

  ResponseBuilder = Proc.new do |http|
    ResponseProxy.new(http.response,
                      http.response_header.status)
  end

  class Request
    def adapter
      @adapter ||= EventMachine::HttpRequest
    end

    # Performs an asynchronous get and yields response to a block.
    def aget(&block)
      http = EM::HttpRequest.new(@request.url).aget
      http.callback { block.call(ResponseBuilder.call(http)) }
      http.errback  { block.call(ResponseBuilder.call(http)) }
    end

    # Performs a synchronous get and returns the response.
    def get
      http = EM::HttpRequest.new(@request.url).get
      ResponseBuilder.call(http)
    end
  end
end
