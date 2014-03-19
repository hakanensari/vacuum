req = Vacuum.new
req.associate_tag = 'foobar'
# Amazon now only paginates to page 5.
params = {
  'SearchIndex' => 'All',
  'Keywords'    => 'Architecture',
  'ItemPage'    => 1
}
@res = req.item_search(query: params)
