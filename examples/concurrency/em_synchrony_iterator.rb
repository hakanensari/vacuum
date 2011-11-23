require File.expand_path('../../helper.rb', __FILE__)

require 'em-synchrony'
require 'em-synchrony/em-http'

module Vacuum
  class Request
    def aget(&blk)
      http = EM::HttpRequest.new(url).aget
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

EM.synchrony do
  all = EM::Synchrony::Iterator.new(locales, 8).map do |locale, iter|
    req = Vacuum.new locale
    req << { 'Version'                         => '2010-11-01',
             'Operation'                       => 'ItemLookup',
             'ItemLookup.Shared.IdType'        => 'ASIN',
             'ItemLookup.Shared.Condition'     => 'All',
             'ItemLookup.Shared.MerchantId'    => 'All',
             'ItemLookup.Shared.ResponseGroup' => 'OfferFull,ItemAttributes',
             'ItemLookup.1.ItemId'             => Asin[0, 10],
             'ItemLookup.2.ItemId'             => Asin[10, 10] }
    req.aget { |res| iter.return({ locale => res }) }
  end
  EM.stop

  all = all.inject({}) { |a, res| a.merge(res) }

  binding.pry
end
