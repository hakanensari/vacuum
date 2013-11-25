$:.unshift(File.expand_path('../../lib', __FILE__))
require 'pry'
require 'vacuum'

req = Vacuum.new
req.associate_tag = 'foobar'

scopes = %w(ItemAttributes Images AlternateVersions).join(',')
params = {
  'ItemSearch.Shared.SearchIndex'   => 'Books',
  'ItemSearch.Shared.Power'         => 'Foucault',
  'ItemSearch.Shared.ResponseGroup' => scopes,
  'ItemSearch.1.ItemPage'           => 1,
  'ItemSearch.2.ItemPage'           => 2
}

res = req.item_search(params)
p res.to_h

binding.pry
