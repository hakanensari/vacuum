# Vacuum

[![Build Status][1]][2]
[![Code Climate][3]][4]

![vacuum][5]

## Usage

Vacuum is a Ruby wrapper to the [Amazon Product Advertising API][6].

```ruby
req = Vacuum.new
req.configure key:    'foo',
              secret: 'secret',
              tag:    'biz-val'
req.get query: { 'Operation'   => 'ItemSearch',
                 'SearchIndex' => 'Books',
                 'Keywords'    => 'Architecture' }
```

[1]: https://secure.travis-ci.org/hakanensari/vacuum.png
[2]: http://travis-ci.org/hakanensari/vacuum
[3]: https://codeclimate.com/badge.png
[4]: https://codeclimate.com/github/hakanensari/vacuum
[5]: http://f.cl.ly/items/2k2X0e2u0G3k1c260D2u/vacuum.png
[6]: https://affiliate-program.amazon.com/gp/advertising/api/detail/main.html
