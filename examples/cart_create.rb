@req = Vacuum.new
@req.associate_tag = 'foobar'

@res = @req.cart_create(
  query: {
    'Item.1.ASIN' => '0321127420',
    'Item.1.Quantity' => 1
  }
)
