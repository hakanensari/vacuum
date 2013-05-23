require 'yaml'
require 'vacuum'

req = Vacuum.new('UK')
req.configure(YAML.load_file('amazon.yml'))

params = {
  'Operation'     => 'ItemSearch',
  'SearchIndex'   => 'KindleStore',
  'ResponseGroup' => 'ItemAttributes,Images',
  'Keywords'      => 'Architecture'
}

@res = req.get(query: params)
