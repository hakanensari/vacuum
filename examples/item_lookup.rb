req = Vacuum.new
req.associate_tag = 'foobar'
@res = req.item_lookup(query: { 'IdType' => 'ASIN', 'ItemId' => '0679753354'})
