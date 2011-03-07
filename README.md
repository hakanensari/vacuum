Sucker
======

Sucker is a Nokogiri-based Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html).

Sucker is fast and supports __the entire Amazon API__.

![Hoover](https://github.com/papercavalier/sucker/raw/master/hoover.jpg)

Usage
-----

Read the [API](http://aws.amazon.com/archives/Product%20Advertising%20API).

Set up.

    worker = Sucker.new \
      :locale => :us,
      :key    => api_key,
      :secret => api_secret

Build a request.

    worker << {
      'Operation'     => 'ItemLookup',
      'IdType'        => 'ASIN',
      'ItemId'        => 10.asins,
      'ResponseGroup' => 'ItemAttributes' }

Get a response.

    response = worker.get

Do something.

    if response.valid?
      response.each('Item') do |item|
        pp item
      end
    end

Repeat ad infinitum.

The following are all valid ways to query a response:

    response.find('Item')
    response['Item']
    response.each('Item') { |item| ... }
    items = response.map('Item') { |item| ... }

To dig further into the response:

    p response.valid?,
      response.body,
      response.code,
      response.errors,
      response.has_errors?,
      response.to_hash,
      response.xml

Read further [here](http://rdoc.info/github/papercavalier/sucker/master/frames) and [here](http://relishapp.com/papercavalier/sucker).

Multiple IPs
------------

Amazon limits calls to a venue to one per second per IP address.

If your server has multiple local interfaces, route your requests like so:

    your_ips.each do |ip|
      Thread.new do
        worker.local_ip = ip
        worker.get
      end
    end

Also, consider using [this library](https://github.com/papercavalier/throttler).

Stubbing in Tests
-----------------

Use [VCR](http://github.com/myronmarston/vcr).

Compatibility
-------------

Specs pass against Ruby 1.8.7, Ruby 1.9.2, JRuby 1.5.6, and Rubinius 1.2.1.

Moral of the story
------------------

Don't overabstract a spaghetti API.
