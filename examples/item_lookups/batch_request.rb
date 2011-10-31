require File.expand_path('../../helper.rb', __FILE__)

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

# Using a batch request, you can request up to 20 ASINs at a time. We lock
# our version to `2010-11-01` to retrieve all offers.
asins = %w{
  0816614024 0143105825 0485113600 0816616779 0942299078
  0816614008 144006654X 0486400360 0486417670 087220474X
  0486454398 0268018359 1604246014 184467598X 0312427182
  1844674282 0745640974 0745646441 0826489540 1844672972 }

req << { 'Version'                         => '2010-11-01',
         'Operation'                       => 'ItemLookup',
         'ItemLookup.Shared.IdType'        => 'ASIN',
         'ItemLookup.Shared.Condition'     => 'All',
         'ItemLookup.Shared.MerchantId'    => 'All',
         'ItemLookup.Shared.ResponseGroup' => 'OfferFull',
         'ItemLookup.1.ItemId'             => asins[0, 10],
         'ItemLookup.2.ItemId'             => asins[10, 10] }
resp = req.get

binding.pry
