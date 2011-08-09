require File.expand_path('../helper.rb', __FILE__)

require 'pp'
require 'amazon_product'

locales = AmazonProduct::Locale::HOSTS.keys

locales.each do |locale|
  AmazonProduct[locale].configure do |c|
    c.key    = YOUR_AMAZON_KEY
    c.secret = YOUR_AMAZON_SECRET
    c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
  end
end

threads = locales.map do |locale|
  Thread.new do
    request = AmazonProduct[locale]
    request << {
      :id_type   => 'ASIN',
      :item_id   => '0143105825' }
    Thread.current[:items] = request.get_item['Item']
  end
end

items = threads.map do |thread|
  thread.join
  thread[:items]
end

pp items
puts items.size
