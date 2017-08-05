req = Vacuum.new('US')
req.version = '2013-04-01'
req.associate_tag = 'foo'
query = {
  'Condition' => 'All',
  'ItemId' => '0060936223',
  'MerchantId' => 'All',
  'ResponseGroup' => 'ItemAttributes,OfferFull,ShippingCharges'
}
res = req.item_lookup(query: query)
res.to_h
