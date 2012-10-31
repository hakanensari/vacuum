require_relative 'slime'

require 'yaml'
require 'vacuum'

req = Vacuum.new
req.configure YAML.load_file 'amazon.yml'

# Also try SearchIndex: 'Books' and Power: 'Architecture binding:kindle'.
res = req.get query: { 'Operation'     => 'ItemSearch',
                       'SearchIndex'   => 'KindleStore',
                       'ResponseGroup' => 'ItemAttributes,Images',
                       'Keywords'      => 'Architecture' }
