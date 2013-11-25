$:.unshift(File.expand_path('../../lib', __FILE__))
require 'pry'
require 'vacuum'

req = Vacuum.new
req.associate_tag = 'foobar'

params = {
  'SearchIndex' => 'All',
  'Keywords'    => 'Architecture'
}

res = req.item_search(params)
p res.to_h

binding.pry
