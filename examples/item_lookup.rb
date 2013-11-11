$:.unshift(File.expand_path('../../lib', __FILE__))
require 'pry'
require 'vacuum'

credentials = YAML.load_file(File.expand_path('../amazon.yml', __FILE__))

req = Vacuum.new
req.configure(credentials)

scopes = %w(
  AlternateVersions Images ItemAttributes SalesRank Similarities
).join ','

params = {
  'IdType'        => 'ASIN',
  'ResponseGroup' => scopes,
  'ItemId'        => '0679753354'
}

res = req.item_lookup(params)
puts res.to_h

binding.pry
