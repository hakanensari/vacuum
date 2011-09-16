require File.expand_path('../../helper.rb', __FILE__)

AmazonProduct::Request.adapter = :synchrony

locales = AmazonProduct::Locale::LOCALES

locales.each do |locale|
  AmazonProduct[locale].configure do |c|
    c.key    = AMAZON_KEY
    c.secret = AMAZON_SECRET
    c.tag    = AMAZON_ASSOCIATE_TAG
  end
end

# Really fat requests executed evented and in parallel.
resps = nil
EM.synchrony do
  concurrency = 8

  resps = EM::Synchrony::Iterator.new(locales, concurrency).map do |locale, iter|
    req = AmazonProduct[locale]
    req << { 'Operation'                       => 'ItemLookup',
             'Version'                         => '2010-11-01',
             'ItemLookup.Shared.IdType'        => 'ASIN',
             'ItemLookup.Shared.Condition'     => 'All',
             'ItemLookup.Shared.MerchantId'    => 'All',
             'ItemLookup.Shared.ResponseGroup' => %w{OfferFull ItemAttributes Images},
             'ItemLookup.1.ItemId'             => Asin[0, 10],
             'ItemLookup.2.ItemId'             => Asin[10, 10] }
    req.aget { |resp| iter.return(resp) }
  end
  EM.stop
end

binding.pry
