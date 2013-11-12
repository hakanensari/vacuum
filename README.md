# Vacuum

[![Build Status][1]][2]

Vacuum is a Ruby wrapper to the [Amazon Product Advertising API][4].

![vacuum][3]

## Usage

Set up a request:

```ruby
req = Vacuum.new
```

The locale defaults to the US. If you wish to use another locale, instantiate
with its two-letter country code:

```ruby
req = Vacuum.new('GB')
```

Configure the request credentials:

```ruby
req.configure(
    aws_access_key_id:     'key',
    aws_secret_access_key: 'secret',
    associate_tag:         'tag'
)
```

Make a request:

```ruby
params = {
  'SearchIndex' => 'Books',
  'Keywords'    => 'Architecture'
}
res = req.item_search(params)
```

Parse the response into a Ruby hash:

```ruby
res.to_h
```

Allowed requests include `browse_node_lookup`, `cart_add`, `cart_clear`,
`cart_create`, `cart_get`, `cart_modify`, `item_lookup`, `item_search`,
`similarity_lookup`.

Vacuum uses [excon][5] and [multi_xml][6].

[1]: https://secure.travis-ci.org/hakanensari/vacuum.png
[2]: http://travis-ci.org/hakanensari/vacuum
[3]: http://f.cl.ly/items/2k2X0e2u0G3k1c260D2u/vacuum.png
[4]: https://affiliate-program.amazon.com/gp/advertising/api/detail/main.html
[5]: https://github.com/geemus/excon
[6]: https://github.com/sferik/multi_xml
