require 'pp'
require 'sucker'

request = Sucker.new(:key    => ENV['AMAZON_KEY'],
                     :secret => ENV['AMAZON_SECRET'],
                     :tag    => ENV['AMAZON_ASSOCIATE_TAG'],
                     :locale => 'us')
request << {
  :operation      => 'ItemLookup',
  :id_type        => 'ASIN',
  :item_id        => '0816614024',
  :merchant_id    => 'All',
  :condition      => 'All',
  :response_group => ['ItemAttributes', 'OfferFull'] }
pp request.get['Item']

request << { :item_id => '048511335X' }
pp request.get['Item']

request << { :item_id => 'B000002GYR' }
#pp request.get['Item']

request << { :item_id   => '0007218095' }
#pp request.get['Errors']
