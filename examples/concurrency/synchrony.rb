require File.expand_path('../../helper.rb', __FILE__)

require 'em-synchrony'
require 'em-synchrony/em-http'

# Monkey-patch request to use EM::HTTP::Request
module Vacuum
  class Request
    # Performs an asynchronous request with the EM async HTTP client
    def aget(&block)
      unless adapter == :synchrony
        raise TypeError, "Set HTTP client to :synchrony"
      end

      http = EM::HttpRequest.new(url).aget
      resp = lambda { Response.new(http.response, http.response_header.status) }
      http.callback { block.call(resp.call) }
      http.errback  { block.call(resp.call) }
    end

    def get
      http = EM::HttpRequest.new(url).get

      Response.new(http.response, http.response_header.status)
    end
  end
end

req = Vacuum['us']

req.configure do |c|
  c.key    = AMAZON_KEY
  c.secret = AMAZON_SECRET
  c.tag    = AMAZON_ASSOCIATE_TAG
end

resp = nil
EM.synchrony do
  resp = req.find('0816614024')
  EM.stop
  resp
end

binding.pry
