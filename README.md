# Vacuum

[![travis][1]][2]

Vacuum is a thin Ruby wrapper to the [Amazon Product Advertising API][3].

![vacuum][4]

## Usage

Make a request:

```ruby
request = Vacuum.new

request.configure key:    'foo',
                  secret: 'secret',
                  tag:    'foo-bar'

request.get query: { 'Operation'   => 'ItemSearch',
                     'SearchIndex' => 'Books',
                     'Keywords'    => 'Architecture' }
```

Parse the response.

[1]: https://secure.travis-ci.org/hakanensari/vacuum.png
[2]: http://travis-ci.org/hakanensari/vacuum
[3]: https://affiliate-program.amazon.com/gp/advertising/api/detail/main.html
[4]: http://f.cl.ly/items/2k2X0e2u0G3k1c260D2u/vacuum.png
