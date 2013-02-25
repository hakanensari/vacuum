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

opts = (1..5).map { |page|
  req.send(:build_options,
    :method => :get,
    :query  => params.dup.update('ItemPage' => page)
  )
}

res_ary = req.connection.requests opts
