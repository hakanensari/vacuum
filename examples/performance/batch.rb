require 'yaml'
require 'vacuum'

creds = YAML.load_file 'amazon.yml'

req = Vacuum.new
req.configure creds

scopes = %w(
  ItemAttributes Images AlternateVersions
).join(',')

params = {
  'Operation'                       => 'ItemSearch',
  'ItemSearch.Shared.SearchIndex'   => 'Books',
  'ItemSearch.Shared.Power'         => 'Foucault',
  'ItemSearch.Shared.ResponseGroup' => scopes,
  'ItemSearch.1.ItemPage'           => 1,
  'ItemSearch.2.ItemPage'           => 2
}

res = req.get query: params
