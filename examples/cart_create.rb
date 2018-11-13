# frozen_string_literal: true

req = Vacuum.new
req.associate_tag = 'foo'
query = {
  'Item.1.ASIN' => 'B00OQVZDJM',
  'Item.1.Quantity' => 1
}
res = req.cart_create(query: query)
res.to_h
