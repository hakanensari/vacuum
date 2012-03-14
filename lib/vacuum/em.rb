require 'vacuum'
require 'em-http-request'

module Vacuum
  class Request
    # Performs an async request.
    #
    # @param err [Proc] A callback to be executed if request fails
    # @yield Passes response to given block
    def aget(err = nil, &blk)
      http = EM::HttpRequest.new(url).get
      # @todo Consider using a SAX parser that can work on the chunks as they
      # come in?
      # http.stream { |chunk| parse chunk }
      http.callback do
        yield Response.new http.response, http.response_header.status
      end
      http.errback &err if err
    end
  end
end
