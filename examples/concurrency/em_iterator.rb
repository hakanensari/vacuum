require File.expand_path('../../helper.rb', __FILE__)

require 'em-http-request'

# Monkey-patch request to use EM::HTTP::Request
module Vacuum
  class Request
    def get(&blk)
      http = EM::HttpRequest.new(url).get
      res = lambda {
        body, status = http.response, http.response_header.status

        Response.new(body, status)
      }

      http.callback do
        blk.call res.call
      end

      http.errback do
        blk.call res.call
      end
    end
  end
end

locales = Vacuum::Locale::LOCALES

locales.each do |locale|
  Vacuum.configure locale do |c|
    c.key    = KEY
    c.secret = SECRET
    c.tag    = ASSOCIATE_TAG
  end
end

EM.run do
  EM::Iterator.new(locales, 8).map(
    proc { |locale, iter|
      req = Vacuum.new(locale)
      req << { 'Operation' => 'ItemLookup',
              'ItemId'    => '0143105825' }
      req.get { |res| iter.return({ locale => res }) }
    }, proc { |all|
      all = all.inject({}) { |a, res| a.merge(res) }
      binding.pry
      EM.stop
    })
end
