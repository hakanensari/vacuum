$:.unshift(File.expand_path('../../lib', __FILE__))
require 'pry'
require 'vacuum'

credentials = YAML.load_file(File.expand_path('../amazon.yml', __FILE__))

req = Vacuum.new
req.configure(credentials)

scopes = %w(
  ItemAttributes Images AlternateVersions
).join(',')

params = {
  'ItemSearch.Shared.SearchIndex'   => 'Books',
  'ItemSearch.Shared.Power'         => 'Foucault',
  'ItemSearch.Shared.ResponseGroup' => scopes,
  'ItemSearch.1.ItemPage'           => 1,
  'ItemSearch.2.ItemPage'           => 2
}

res = req.item_search(params)
puts res.to_h

binding.pry
