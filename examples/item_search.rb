require 'yaml'
require 'vacuum'

creds = YAML.load_file 'amazon.yml'

req = Vacuum.new
req.configure creds

params = {
  'Operation'     => 'ItemSearch',
  'SearchIndex'   => 'KindleStore',
  'ResponseGroup' => 'ItemAttributes,Images',
  'Keywords'      => 'Architecture'
}

res = req.get expects: 200,
              query:   params
