# Vacuum

[![Build Status][1]][2]

Vacuum is a fast, light-weight Ruby wrapper to the [Amazon Product Advertising API][4].

![vacuum][3]

## Usage

### Setup

Set up a request:

```ruby
req = Vacuum.new
```

The locale defaults to the US. To use another locale, instantiate with its
two-letter country code:

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

Alternatively, set the key and secret as environment variables globally:

```sh
export AWS_ACCESS_KEY_ID=key
export AWS_SECRET_ACCESS_KEY=secret
```

You will still need to set a distinct associate tag for each locale:

```ruby
req.associate_tag = 'tag'
```

### Request

Set up your parameters and make a request:

```ruby
params = {
  'SearchIndex' => 'Books',
  'Keywords'    => 'Architecture'
}
res = req.item_search(query: params)
```
The above executes an item search operation. The names of available methods
derive from the operations listed in the API docs and include
`browse_node_lookup`, `cart_add`, `cart_clear`, `cart_create`, `cart_get`,
`cart_modify`, `item_lookup`, `item_search`, and `similarity_lookup`.

Vacuum uses [Excon][5] as HTTP client. Check the Excon API for ways to tweak
your request:

```ruby
res = req.item_search(query: params, persistent: true)
```

### Response

The quickest way to consume a response is to parse it into a Ruby hash:

```ruby
res.to_h
```

Vacuum uses [MultiXml][6], which will work with a number of popular XML
libraries. If working in MRI, you may want to use [Ox][7].

You can also pass the response body into your own parser for some custom XML
heavy-lifting:

```ruby
MyParser.new(res.body)
```

[1]: https://secure.travis-ci.org/hakanensari/vacuum.png
[2]: http://travis-ci.org/hakanensari/vacuum
[3]: http://f.cl.ly/items/2k2X0e2u0G3k1c260D2u/vacuum.png
[4]: https://affiliate-program.amazon.com/gp/advertising/api/detail/main.html
[5]: https://github.com/geemus/excon
[6]: https://github.com/sferik/multi_xml
[7]: https://github.com/ohler55/ox
