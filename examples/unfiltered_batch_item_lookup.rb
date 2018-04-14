# frozen_string_literal: true

req = Vacuum.new
req.version = '2013-04-01'
req.associate_tag = 'foo'
query = {
  'ItemLookup.Shared.Condition' => 'All',
  'ItemLookup.Shared.ItemId' => '0912383119',
  'ItemLookup.Shared.MerchantId' => 'All',
  'ItemLookup.Shared.ResponseGroup' => 'OfferFull,ShippingCharges',
  'ItemLookup.1.OfferPage' => 1,
  'ItemLookup.2.OfferPage' => 2
}
res = req.item_lookup(query: query)
# Return up to 20 offers in an array.
batches = res.dig('ItemLookupResponse', 'Items')
batches.map { |items| items.dig('Item', 'Offers', 'Offer') }.flatten
