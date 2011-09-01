require File.expand_path('../../helper.rb', __FILE__)

req = AmazonProduct['us']

req.configure do |c|
  c.key    = YOUR_AMAZON_KEY
  c.secret = YOUR_AMAZON_SECRET
  c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
end

# Get a random offer listing ID for an item.
resp = req.find('0816614024', :merchant_id    => 'All',
                              :condition      => 'All',
                              :response_group => 'Offers')
olid = resp['OfferListingId'].first

req.create_cart 'Item.1.OfferListingId' => olid,
                'Item.1.Quantity'       => 1

binding.pry
