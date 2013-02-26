require 'benchmark'
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

Benchmark.bm(8) do |x|
  conn = req.connection

  x.report('pipeline:') do
    conn.requests opts
  end

  x.report('threads:') do
    opts
      .map { |opt| Thread.new { Thread.current[:res] = conn.request opt } }
      .map { |thr| thr.join[:res] }
  end
end
