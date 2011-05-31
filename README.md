Sucker
======

Sucker is a Nokogiri-based Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html).

![Hoover](https://github.com/papercavalier/sucker/raw/master/hoover.jpg)

Caption: Workers queuing to download data from Amazon.

Usage
-----

Read the [Amazon API](http://aws.amazon.com/archives/Product%20Advertising%20API).
Check out [these examples](http://relishapp.com/papercavalier/sucker) if in a hurry.

Set up.

    request = Sucker.new(
      :locale => :us,
      :key    => amazon_key,
      :secret => amazon_secret)

Build a request.

    request << {
      'Operation'     => 'ItemLookup',
      'IdType'        => 'ASIN',
      'ItemId'        => 10.asins,
      'ResponseGroup' => 'ItemAttributes' }

Get a response.

    response = request.get

Fulfill a business value.

    if response.valid?
      response.each('Item') do |item|
        consume(item)
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

To use multiple local IPs on your server, configure the request adapter:

    adapter = request.adapter
    adapter.socket_local.host = '10.0.0.2'

[Browse the public interface of Sucker.](http://rdoc.info/github/papercavalier/sucker/master/frames)

Stubbing Tests
--------------

Try [VCR](http://github.com/myronmarston/vcr).

Moral of the story
------------------

Don't overabstract a spaghetti API.
