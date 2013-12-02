$:.unshift(File.expand_path('../../lib', __FILE__))
require 'pry'
require 'vacuum'

req = Vacuum.new
req.associate_tag = 'foobar'

# Amazon now only paginates to page 5.
params = {
  'SearchIndex' => 'All',
  'Keywords'    => 'Architecture',
  'ItemPage'    => 1
}

res = req.item_search(params)
p res.to_h

binding.pry
