require File.expand_path('../../helper.rb', __FILE__)

req = Vacuum['us']

req.configure do |c|
  c.key    = AMAZON_KEY
  c.secret = AMAZON_SECRET
  c.tag    = AMAZON_ASSOCIATE_TAG
end

# Get a random offer listing ID for an item.
resp = req.find('0816614024', :response_group => 'Offers')
olid = resp['OfferListingId'].first

# Create a cart
cart = req.create_cart 'Item.1.OfferListingId' => olid,
                       'Item.1.Quantity'       => 1

# Remove added item from cart
cart.modify({ 'Item.1.CartItemId' => cart.items.first['CartItemId'],
              'Item.1.Quantity' => 0 })

# And add it back!
cart.add({ 'Item.1.OfferListingId' => olid, 'Item.1.Quantity' => 1})

binding.pry
