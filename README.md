# Vacuum

[![travis] [1]] [2]

Vacuum is a thin Ruby wrapper to various [Amazon Web Services (AWS) APIs] [3].

![vacuum] [4]

## Installation

```sh
gem install vacuum
```

## Amazon Product Advertising API

Vacuum knows the [Amazon Product Advertising API] [5] inside out.

Set up a request:

```ruby
req = Vacuum.new :product_advertising

req.configure do |config|
  config.key    'key'
  config.secret 'secret'
  config.tag    'tag'
end
```

Build and run a search:

```ruby
req.build operation:    'ItemSearch',
          search_index: 'Books',
          keywords:     'Deleuze'
res = req.get
```

Or accomplish the same search less verbosely:

```ruby
res = req.search :books, 'Deleuze'
```

The response wraps a [Nokogiri] [6] document:

```ruby
res.xml
```

And lets you drop down to any node:

```ruby
if res.valid?
  res.find('Item') do |item|
    p item
  end
end
```

You will find more examples [here] [7].

## Amazon Marketplace Web Services API

The wrapper to the [Amazon Marketplace Web Services API] [8] is a
work-in-progress.

Set up a request to the Products API:

```ruby
req = Vacuum.new(:mws_products) do |config|
  config.locale      'US'
  config.key         'key'
  config.secret      'secret'
  config.marketplace 'marketplace'
  config.seller      'seller'
end
```

Get the lowest offers for a single ASIN:

```ruby
req.build 'Action'          => 'GetLowestOfferListingsForASIN',
          'ASINList.ASIN.1' => '0231081596'
offers = req.get.find 'GetLowestOfferListingsForASINResult'
```

I will at some point throw in some syntactic sugar for common operations.

## Other AWS APIs

Vacuum should work with all AWS libraries, including EC2, S3, IAM, SimpleDB,
SQS, SNS, SES, and ELB. Most of these already have popular Ruby
implementations. If you need to implement one using Vacuum, please fork and
send a pull request when done.

## HTTP Client Adapters

You can use any of the alternative adapters [Faraday] [9] supports:

```ruby
req.connection do |builder|
  builder.adapter :em_synchrony
end
```

![vacuums] [9]

> Workers queuing to crawl AWS.

[1]: https://secure.travis-ci.org/hakanensari/vacuum.png
[2]: http://travis-ci.org/hakanensari/vacuum
[3]: http://aws.amazon.com/
[4]: http://f.cl.ly/items/2k2X0e2u0G3k1c260D2u/vacuum.png
[5]: https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html
[6]: http://nokogiri.org/
[7]: https://github.com/hakanensari/vacuum/blob/master/examples/product_advertising/
[8]: https://developer.amazonservices.com/gp/mws/docs.html
[9]: https://github.com/technoweenie/faraday
[10]: http://f.cl.ly/items/1Q3W372A0H3M0w2H1e0W/hoover.jpeg
