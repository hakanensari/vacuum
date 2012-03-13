# Vacuum

[![travis] [1]] [2]

![vacuum] [3]

Vacuum is a minimal Ruby wrapper to the [Amazon Product Advertising API] [4].

# Usage

```ruby
require 'vacuum'

# Create a request.
req = Vacuum.new key:    'key',
                 secret: 'secret',
                 tag:    'tag',
                 locale: 'us'

# Build query.
req.build 'Operation'   => 'ItemSearch',
          'SearchIndex' => 'All',
          'Keywords'    => 'Gilles Deleuze'

# Execute.
res = request.get

# Consume response.
if res.valid?
  # res.to_hash
  res.find('Item') do |item|
    p item['ASIN']
  end
end
```

Read further [here] [5].

[1]: https://secure.travis-ci.org/hakanensari/vacuum.png
[2]: http://travis-ci.org/hakanensari/vacuum
[3]: http://f.cl.ly/items/2k2X0e2u0G3k1c260D2u/vacuum.png
[4]: https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html
[5]: https://github.com/hakanensari/vacuum/blob/master/examples/
