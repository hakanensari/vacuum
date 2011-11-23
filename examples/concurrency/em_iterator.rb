require File.expand_path('../../helper.rb', __FILE__)

require 'em-http-request'

module Vacuum
  class Request
    def get(&blk)
      http = EM::HttpRequest.new(url).get
      http.callback { blk.call async_response(http) }
      http.errback  { blk.call async_response(http) }
    end

    private

    def async_response(http)
      body, status = http.response, http.response_header.status

      Response.new(body, status)
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
