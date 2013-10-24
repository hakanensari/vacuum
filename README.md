# Vacuum

[![Build Status][1]][2]

Vacuum is a Ruby wrapper to the [Amazon Product Advertising API][4].

![vacuum][3]

## Usage

Set up a request:

```ruby
req = Vacuum.new
  .configure(
    aws_access_key_id:     'foo',
    aws_secret_access_key: 'secret',
    associate_tag:         'biz-val'
  )
```

The locale defaults to the US. If you wish to use another locale, specify its
ISO-3166 two-letter code when instantiating the request:

```ruby
Vacuum.new('GB')
```

Make a request:

```ruby
params = { 'Operation'   => 'ItemSearch',
           'SearchIndex' => 'Books',
           'Keywords'    => 'Architecture' }

res = req.get(query: params)
```

Once you have a response, parse it with your favourite XML parser and parsing
method. XML is stored in the Object's body.

[`Nokogiri`][5]:

```
res = res.body
xml = Nokogiri::XML(res)
```

If you don't mind the performance hit, here is a simplistic solution based on
[`MultiXml`][5]:

```ruby
require 'forwardable'
require 'multi_xml'

class Response
  extend Forwardable

  def_delegators :@response, :code, :body

  def initialize(response)
    @response = response
  end

  def to_h
    MultiXml.parse(body)
  end
end

Response.new(res).to_h
```

[1]: https://secure.travis-ci.org/hakanensari/vacuum.png
[2]: http://travis-ci.org/hakanensari/vacuum
[3]: http://f.cl.ly/items/2k2X0e2u0G3k1c260D2u/vacuum.png
[4]: https://affiliate-program.amazon.com/gp/advertising/api/detail/main.html
[5]: https://github.com/sferik/multi_xml
[6]: https://github.com/sparklemotion/nokogiri
