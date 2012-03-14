require 'vacuum'
require 'em-http-request'

module Vacuum
  class Request
    # Performs an async request.
    #
    # @yield Passes response to given block
    def aget(&blk)
      http = EM::HttpRequest.new(url).get
      # @todo Consider using a SAX parser that can work on the chunks as they
      # come in?
      # http.stream { |chunk| parse chunk }
      http.callback { blk.call _response(http) }
      http.errback  { blk.call _response(http) }

      nil
    end

    private

    def _response(http)
      Response.new(http.response, http.response_header.status)
    end
  end
end
