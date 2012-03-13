require File.expand_path('../helper.rb', __FILE__)
require 'vacuum'

req = Vacuum.new :key    => KEY,
                 :secret => SECRET,
                 :tag    => TAG

# Using a batch request, you can request up to 20 ASINs at a time.
req.build 'Operation'                       => 'ItemLookup',
          'ItemLookup.Shared.IdType'        => 'ASIN',
          'ItemLookup.Shared.Condition'     => 'All',
          'ItemLookup.Shared.MerchantId'    => 'All',
          'ItemLookup.Shared.ResponseGroup' => 'OfferFull',
          'ItemLookup.1.ItemId'             => Asin[0, 10],
          'ItemLookup.2.ItemId'             => Asin[10, 10]
items = req.get.find 'Item'

binding.pry
