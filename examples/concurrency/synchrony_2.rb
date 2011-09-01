require File.expand_path('../../helper.rb', __FILE__)

AmazonProduct::Request.adapter = :synchrony

locales = AmazonProduct::Locale::LOCALES
asins   = %w{ 0816614024 0143105825 0485113600 }

locales.each do |locale|
  AmazonProduct[locale].configure do |c|
    c.key    = YOUR_AMAZON_KEY
    c.secret = YOUR_AMAZON_SECRET
    c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
  end
end

# Multiple evented requests executed in parallel.
resps = nil
EM.synchrony do
  concurrency = 8

  resps = EM::Synchrony::Iterator.new(asins.product(locales), concurrency).map do |(asin, locale), iter|
    req = AmazonProduct[locale]
    req << { :operation => 'ItemLookup',
             :item_id => asin }
    req.aget { |resp| iter.return(resp) }
  end
  EM.stop
end

binding.pry
