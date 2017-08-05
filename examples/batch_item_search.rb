req = Vacuum.new
req.associate_tag = 'foobar'
query = {
  'ItemSearch.Shared.SearchIndex'   => 'All',
  'ItemSearch.Shared.Keywords'      => 'Foucault',
  'ItemSearch.Shared.ResponseGroup' => 'ItemAttributes,Images,Offers',
  'ItemSearch.1.ItemPage'           => 1,
  'ItemSearch.2.ItemPage'           => 2
}
res = req.item_search(query: query)
res.to_h
