$:.unshift(File.expand_path('../../lib', __FILE__))
require 'pry'
require 'vacuum'

credentials = YAML.load_file(File.expand_path('../amazon.yml', __FILE__))

req = Vacuum.new
req.configure(credentials)

params = {
  'SearchIndex'   => 'KindleStore',
  'ResponseGroup' => 'ItemAttributes,Images',
  'Keywords'      => 'Architecture'
}

res = req.item_search(params)
puts res.to_h

binding.pry
