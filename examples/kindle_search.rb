$:.unshift File.expand_path('../../lib', __FILE__)

require 'pry'
require 'yaml'
require 'vacuum'

req = Vacuum.new
req.configure YAML.load_file File.expand_path '../amazon.yml', __FILE__

# Also try setting SearchIndex to 'Books' and Power to
# 'Architecture binding:kindle'.

res = req.get query: { 'Operation'     => 'ItemSearch',
                       'SearchIndex'   => 'KindleStore',
                       'ResponseGroup' => 'ItemAttributes,Images',
                       'Keywords'      => 'Architecture' }

binding.pry
