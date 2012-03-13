# Vacuum

[![travis] [2]] [3]

![vacuum] [1]

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

[1]: https://github.com/hakanensari/vacuum/blob/master/vacuum.png?raw=true
[2]: https://secure.travis-ci.org/hakanensari/vacuum.png
[3]: http://travis-ci.org/hakanensari/vacuum
[4]: https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html
[5]: https://github.com/hakanensari/vacuum/blob/master/examples/
