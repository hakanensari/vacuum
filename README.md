# Vacuum

[![travis] [1]] [2]

![vacuum] [3]

Vacuum is a [Faraday] [4]- and [Nokogiri] [5]-based Ruby wrapper to various
[Amazon Web Services (AWS) APIs] [6].

## [Amazon Product Advertising API] [7]

```ruby
require 'vacuum'

# Set up a request.
req = Vacuum.new(:product_advertising) do |config|
  config.key    'key'
  config.secret 'secret'
  config.tag    'tag'
  config.locale 'us'
end

# Build a query.
req.build operation:    'ItemSearch',
          search_index: 'All',
          keywords:     'widget'

# Use an alternative HTTP adapter.
# req.connection do |builder|
#   builder.adapter :typhoeus
# end

# Execute.
res = request.get

# Consume response.
if res.valid?
  # res.code
  # res.body
  # res.xml
  # res.to_hash
  res.find('Item') do |item|
    p item['ASIN']
  end
end
```

Read further [here] [8].

## [Amazon Marketplace Web Services API] [9]

req = Vacuum.new(:mws_products)
req.configure do |config|
  config.locale      'us'
  config.key         'key'
  config.secret      'secret'
  config.marketplace 'marketplace'
  config.seller      'seller'
end

req.build operation:    'ItemSearch',
          search_index: 'All',
          keywords:     'widget'

## Other AWS APIs

Vacuum should also work with EC2, S3, SimpleDB, SQS, SNS, SES, ELB, CW,
and what have you. Feel free to implement and send over a pull request.

[1]: https://secure.travis-ci.org/hakanensari/vacuum.png
[2]: http://travis-ci.org/hakanensari/vacuum
[3]: http://f.cl.ly/items/2k2X0e2u0G3k1c260D2u/vacuum.png
[4]: https://github.com/technoweenie/faraday
[5]: https://nokogiri/
[6]: http://aws.amazon.com/
[7]: https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html
[8]: https://github.com/hakanensari/vacuum/blob/master/examples/product_advertising/
[9]: https://developer.amazonservices.com/gp/mws/docs.html
