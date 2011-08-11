# Amazon Product

Amazon Product is a Ruby wrapper to the [Amazon Product Advertising API] [1].

[![travis](https://secure.travis-ci.org/hakanensari/amazon_product.png)](http://travis-ci.org/hakanensari/amazon_product)

## Usage

Set up a request.

    require "amazon_product"

    request = AmazonProduct["us"]

    request.configure do |c|
      c.key    = YOUR_AMAZON_KEY
      c.secret = YOUR_AMAZON_SECRET
      c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
    end

Look up a product.

    request << { :operation' => 'ItemLookup',
                 :item_id'   => '0679753354' }
    response = request.get

[Or use a shorthand] [2].

    response = req.find('0679753354')

Consume the entire response.

    response.to_hash

Quickly drop down to a particular node.

    response['Item']

Please see [the project page] [3] for more detailed info.

[1]: https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html

[2]: https://github.com/hakanensari/amazon_product/blob/master/lib/amazon_product/operations.rb

[3]: http://code.papercavalier.com/amazon_product/
