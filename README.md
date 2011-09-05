# Amazon Product

Amazon Product is a [Nokogiri][1]-backed Ruby wrapper to the [Amazon
Product Advertising API] [2].

[![travis](https://secure.travis-ci.org/hakanensari/amazon_product.png)](http://travis-ci.org/hakanensari/amazon_product)

## Installation

Add to your Gemfile.

    gem 'amazon_product'

## Usage

Set up a request.

    require "amazon_product"

    req = AmazonProduct["us"]

    req.configure do |c|
      c.key    = AMAZON_KEY
      c.secret = AMAZON_SECRET
      c.tag    = AMAZON_ASSOCIATE_TAG
    end

Look up a product.

    req << { :operation' => 'ItemLookup',
             :item_id'   => '0679753354' }
    resp = request.get

[Or use a shorthand] [3].

    resp = req.find('0679753354')

Consume the entire response.

    resp.to_hash

Quickly drop down to a particular node.

    resp['Item']

[Please see the project page] [4] for further detail.

## Adapters

Amazon Product defaults to the Net::HTTP library but can be configured
to use Curb or EM-HTTP-Request.

## Branding is a delicate art

Amazon Product descends from [Sucker][5]. While I still like the vacuum
metaphor, the name felt tiring after a while.

[1]: http://nokogiri.org/
[2]: https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html
[3]: https://github.com/hakanensari/amazon_product/blob/master/lib/amazon_product/operations.rb
[4]: http://code.papercavalier.com/amazon_product/
[5]: http://github.com/papercavalier/sucker/
