Sucker
======

Sucker is a Nokogiri-based Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html).

![Hoover](https://github.com/papercavalier/sucker/raw/master/hoover.jpg)

Usage
-----

Read [Amazon's API](http://aws.amazon.com/archives/Product%20Advertising%20API).
Skip to the __Operations__ section if in a hurry.

Set up.

    worker = Sucker.new(
      :locale        => :us,
      :key           => a_key,
      :secret        => a_secret)

Build a request.

    worker << {
      'Operation'     => 'ItemLookup',
      'IdType'        => 'ASIN',
      'ItemId'        => 10.asins,
      'ResponseGroup' => 'ItemAttributes' }

Get a response.

    response = worker.get

Fulfill a business value.

    if response.valid?
      response.each('Item') do |item|
        consume item
      end
    end

Repeat ad infinitum.

The following are all valid ways to query a response:

    items = response.find('Item')
    items = response['Item']
    items = response.map('Item') { |item| ... }
    response.each('Item') { |item| ... }

To dig further into the response object:

    p response.valid?,
      response.body,
      response.code,
      response.errors,
      response.has_errors?,
      response.to_hash,
      response.xml

Browse the public interface of Sucker
[here](http://rdoc.info/github/papercavalier/sucker/master/frames). To see more
advanced usage examples such as twenty-item batch requests and remote cart
manipulation, read [here](http://relishapp.com/papercavalier/sucker).

HTTP adapter
------------
Sucker sports [HTTPI](http://github.com/rubiii/httpi) under the hood, so you
can use `curb` or `httpclient` instead of `Net::HTTP` if you so desire.

Stubbing in Tests
-----------------

Try [VCR](http://github.com/myronmarston/vcr).

Compatibility
-------------

Specs pass against all modern Rubies.

Moral of the story
------------------

Don't overabstract a spaghetti API.
