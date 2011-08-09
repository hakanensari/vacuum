require File.expand_path('../helper.rb', __FILE__)

require 'pp'
require 'amazon_product'

request = AmazonProduct['us']

request.configure do |c|
  c.key    = YOUR_AMAZON_KEY
  c.secret = YOUR_AMAZON_SECRET
  c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
end

# With the latest API version, Amazon will only return lowest-priced offer per
# condition.
request << { :id_type        => 'ASIN',
             :item_id        => '0816614024',
             :merchant_id    => 'All',
             :condition      => 'All',
             :response_group => 'OfferFull' }

response = request.get_item
pp response['OfferSummary']
pp response['Offers']
