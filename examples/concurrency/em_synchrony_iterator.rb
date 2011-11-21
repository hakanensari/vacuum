require File.expand_path('../../helper.rb', __FILE__)

require 'em-synchrony'
require 'em-synchrony/em-http'

# Monkey-patch request to use EM::HTTP::Request
module Vacuum
  class Request
    # Performs an asynchronous request with the EM async HTTP client
    def aget(&block)
      http = EM::HttpRequest.new(url).aget
      res = lambda { Response.new(http.response, http.response_header.status) }
      http.callback { block.call(res.call) }
      http.errback  { block.call(res.call) }
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

EM.synchrony do
  concurrency = 8

  all = EM::Synchrony::Iterator.new(locales, concurrency).map do |locale, iter|
    req = Vacuum.new locale
    req << { 'operation'                       => 'itemlookup',
             'version'                         => '2010-11-01',
             'itemlookup.shared.idtype'        => 'asin',
             'itemlookup.shared.condition'     => 'all',
             'itemlookup.shared.merchantid'    => 'all',
             'itemlookup.shared.responsegroup' => %w{offerfull itemattributes images},
             'itemlookup.1.itemid'             => asin[0, 10],
             'itemlookup.2.itemid'             => asin[10, 10] }
    req.aget { |res| iter.return({ locale => res }) }
  end
  EM.stop

  all = all.inject({}) { |a, res| a.merge(res) }

  binding.pry
end
