require 'yaml'
require 'vacuum'

creds = YAML.load_file 'amazon.yml'

req = Vacuum.new
req.configure creds

scopes = %w(
  AlternateVersions Images ItemAttributes SalesRank Similarities
).join ','

params = {
  'Operation'     => 'ItemLookup',
  'IdType'        => 'ASIN',
  'ResponseGroup' => scopes,
  'ItemId'        => '0679753354'
}

res = req.get query: params
