require File.expand_path('../../helper.rb', __FILE__)

require 'em-synchrony'
require 'em-synchrony/em-http'

# Monkey-patch request to use EM::HTTP::Request
module Vacuum
  class Request
    # Performs an asynchronous request with the EM async HTTP client
    def aget(&block)
      http = EM::HttpRequest.new(url).aget
      resp = lambda { Response.new(http.response, http.response_header.status) }
      http.callback { block.call(resp.call) }
      http.errback  { block.call(resp.call) }
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

# Really fat requests executed evented and in parallel.
resps = nil
EM.synchrony do
  concurrency = 8

  resps = EM::Synchrony::Iterator.new(locales, concurrency).map do |locale, iter|
    req = Vacuum.new locale
    req << { 'Operation'                       => 'ItemLookup',
             'Version'                         => '2010-11-01',
             'ItemLookup.Shared.IdType'        => 'ASIN',
             'ItemLookup.Shared.Condition'     => 'All',
             'ItemLookup.Shared.MerchantId'    => 'All',
             'ItemLookup.Shared.ResponseGroup' => %w{OfferFull ItemAttributes Images},
             'ItemLookup.1.ItemId'             => Asin[0, 10],
             'ItemLookup.2.ItemId'             => Asin[10, 10] }
    req.aget { |resp| iter.return({ locale => resp }) }
  end
  EM.stop
end

resps = resps.inject({}) { |a, resp| a.merge(resp) }

binding.pry
