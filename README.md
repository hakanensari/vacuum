# Vacuum

[![travis] [1]] [2]

Vacuum is a Ruby wrapper to [various Amazon Web Services (AWS) APIs] [3].

![vacuum] [4]

## Amazon Product Advertising API

Vacuum knows the [Amazon Product Advertising API] [5] [inside out] [6].

```ruby
request = Vacuum.new(:product_advertising) do |config|
  config.locale 'US'

  config.key    'key'
  config.secret 'secret'
  config.tag    'tag'
end

# Use an alternative Faraday adapter.
# request.connection do |builder|
#   builder.adapter :typhoeus
# end

# A barebone search request.
request.build operation:    'ItemSearch',
              search_index: 'Books',
              keywords:     'Deleuze'
response = request.get

# A less verbose search.
request.search :books, 'Deleuze'

if response.valid?
  # response.code
  # response.body
  # response.errors
  # response.xml # The Nokogiri XML doc
  # response.to_hash
  response.find('Item') do |item|
    p item['ASIN']
  end
end
```
## Amazon Marketplace Web Services API

The wrapper to the [Amazon Marketplace Web Services API] [7] is a
work-in-progress.

```ruby
request = Vacuum.new(:mws_products) do |config|
  config.locale      'US'

  config.key         'key'
  config.secret      'secret'
  config.marketplace 'marketplace'
  config.seller      'seller'
end

request.build 'Action'          => 'GetLowestOfferListingsForASIN',
              'ASINList.ASIN.1' => '0231081596'
offers = request.get.find 'GetLowestOfferListingsForASINResult'
```

## Other AWS APIs

Vacuum should work with EC2, S3, IAM, SimpleDB, SQS, SNS, SES, ELB, CW, and so
on. Implement and send a pull request.

# Addendum

![vacuums] [8]

> Workers queuing to crawl AWS.

[1]: https://secure.travis-ci.org/hakanensari/vacuum.png
[2]: http://travis-ci.org/hakanensari/vacuum
[3]: http://aws.amazon.com/
[4]: http://f.cl.ly/items/2k2X0e2u0G3k1c260D2u/vacuum.png
[5]: https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html
[6]: https://github.com/hakanensari/vacuum/blob/master/examples/product_advertising/
[7]: https://developer.amazonservices.com/gp/mws/docs.html
[8]: http://f.cl.ly/items/1Q3W372A0H3M0w2H1e0W/hoover.jpeg
