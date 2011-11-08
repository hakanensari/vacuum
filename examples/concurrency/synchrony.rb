require File.expand_path('../../helper.rb', __FILE__)

require 'em-synchrony'
require 'em-synchrony/em-http'

# Monkey-patch request to use EM::HTTP::Request
module Vacuum
  class Request
    def get
      http = EM::HttpRequest.new(url).get

      Response.new(http.response, http.response_header.status)
    end
  end
end

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

res = nil
EM.synchrony do
  res = req.find('0816614024')
  EM.stop

  binding.pry
end
