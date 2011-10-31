require File.expand_path('../../helper.rb', __FILE__)

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

# Get a random offer listing ID for an item.
resp = req.find('0816614024', :response_group => 'Offers')
olid = resp['OfferListingId'].first

# Create a cart
cart = req.create_cart 'Item.1.OfferListingId' => olid,
                       'Item.1.Quantity'       => 1

# Remove added item from cart
cart.modify({ 'Item.1.CartItemId' => cart.items.first['CartItemId'],
              'Item.1.Quantity'   => 0 })
# you could have also done: cart.clear

# And add the item back!
cart.add({ 'Item.1.OfferListingId' => olid, 'Item.1.Quantity' => 1})

binding.pry
