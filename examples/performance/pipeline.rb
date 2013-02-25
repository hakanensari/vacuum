require 'yaml'
require 'vacuum'
require 'benchmark'

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

Benchmark.bm do |x|
  conn = req.connection

  x.report('pipeline:') do
    conn.requests opts
  end

  x.report('threads:') do
    opts.map { |opt|
      Thread.new { conn.request opt }
    }.each(&:join)
  end
end
