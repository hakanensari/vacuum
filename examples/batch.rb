req = Vacuum.new
req.associate_tag = 'foobar'
rg = %w(ItemAttributes Images AlternateVersions Offers).join(',')
@res = req.item_search(query: {
  'ItemSearch.Shared.SearchIndex'   => 'All',
  'ItemSearch.Shared.Keywords'      => 'Foucault',
  'ItemSearch.Shared.ResponseGroup' => rg,
  'ItemSearch.1.ItemPage'           => 1,
  'ItemSearch.2.ItemPage'           => 2
})
