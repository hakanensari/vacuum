require 'yaml'
require 'vacuum'

req = Vacuum.new
req.configure(YAML.load_file('amazon.yml'))

scopes = %w(
  AlternateVersions Images ItemAttributes SalesRank Similarities
).join ','

params = {
  'Operation'     => 'ItemLookup',
  'IdType'        => 'ASIN',
  'ResponseGroup' => scopes,
  'ItemId'        => '0679753354,039473954X'
}

@res = req.get(query: params)
