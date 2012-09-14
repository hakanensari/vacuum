# Vacuum

[![travis][1]][2]

![vacuum][4]

Vacuum is a Ruby wrapper to the [Amazon Product Advertising API][3].

The API gives you access to the product catalogues of various Amazon websites.

## Usage

```ruby
request = Vacuum.new

request.configure key:    'foo',
                  secret: 'secret',
                  tag:    'foo-bar'

response = request.get query: { 'Operation'   => 'ItemSearch',
                                'SearchIndex' => 'Books',
                                'Keywords'    => 'Architecture' }

# Parse the response.body
```
Read [further][5].

[1]: https://secure.travis-ci.org/hakanensari/vacuum.png
[2]: http://travis-ci.org/hakanensari/vacuum
[3]: https://affiliate-program.amazon.com/gp/advertising/api/detail/main.html
[4]: http://f.cl.ly/items/2k2X0e2u0G3k1c260D2u/vacuum.png
[5]: http://aws.amazon.com/archives/Product%20Advertising%20API
