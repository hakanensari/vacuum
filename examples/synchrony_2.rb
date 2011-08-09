require File.expand_path('../helper.rb', __FILE__)

require 'pp'
require 'amazon_product/synchrony'

# Multiple evented requests executed in parallel.
locales = AmazonProduct::Locale::HOSTS.keys
asins   = %w{ 0816614024 0143105825 0485113600 }

locales.each do |locale|
  AmazonProduct[locale].configure do |c|
    c.key    = YOUR_AMAZON_KEY
    c.secret = YOUR_AMAZON_SECRET
    c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
  end
end

started_at = Time.now

EM.synchrony do
  concurrency = 8

  responses = EM::Synchrony::Iterator.new(asins.product(locales), concurrency).map do |(asin, locale), iter|
    request = AmazonProduct[locale]
    request << { :operation => 'ItemLookup',
                 :id_type => 'ASIN',
                 :item_id => asin }
    request.aget { |response| iter.return(response) }
  end

  EM.stop

  puts responses.map { |response| response['Title'] }.size
  puts "Completed in #{Time.now - started_at} seconds"
end
