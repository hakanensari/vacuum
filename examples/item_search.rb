req = Vacuum.new
req.associate_tag = 'foo'
query = {
  'SearchIndex' => 'All',
  'Keywords' => 'Foucault'
}
res = req.item_search(query: query)
res.to_h
