$:.unshift(File.expand_path('../../lib', __FILE__))
require 'pry'
require 'vacuum'

req = Vacuum.new
req.associate_tag = 'foobar'

scopes = %w(
  AlternateVersions Images ItemAttributes SalesRank Similarities
).join ','

params = {
  'IdType'        => 'ASIN',
  'ResponseGroup' => scopes,
  'ItemId'        => '0679753354'
}

res = req.item_lookup(params)
p res.to_h

binding.pry
