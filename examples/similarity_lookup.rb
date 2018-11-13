# frozen_string_literal: true

req = Vacuum.new
req.associate_tag = 'foo'
query = {
  'ItemId' => '0912383119'
}
res = req.similarity_lookup(query: query)
res.to_h
