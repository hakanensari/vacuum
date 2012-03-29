require File.expand_path('../shared.rb', __FILE__)

# Get a random offer listing ID for an item.
@req.build 'Operation'     => 'ItemLookup',
           'ResponseGroup' => 'Offers',
           'ItemId'        => '0816614024'
olid = @req.get.find('OfferListingId').first

# Create a cart
@req.build! 'Operation'             => 'CartCreate',
            'Item.1.OfferListingId' => olid,
            'Item.1.Quantity'       => 1
res = @req.get

binding.pry
