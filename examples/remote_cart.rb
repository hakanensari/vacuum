require File.expand_path('../helper.rb', __FILE__)

require 'pp'
require 'amazon_product'

request = AmazonProduct['us']

request.configure do |c|
  c.key    = YOUR_AMAZON_KEY
  c.secret = YOUR_AMAZON_SECRET
  c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
end

# Let's get an offer listing ID.
request << { :id_type        => 'ASIN',
             :item_id        => '0816614024',
             :merchant_id    => 'All',
             :condition      => 'All',
             :response_group => 'Offers' }

response = request.get_item
offer_listing_id = response['OfferListingId'].first

request.reset
request << {
  'Item.1.OfferListingId' => offer_listing_id,
  'Item.1.Quantity'       => 1 }

cart = request.create_cart['Cart']
pp cart
