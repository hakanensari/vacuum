Sucker
======

Sucker is a Nokogiri-based Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html).

Sucker is fast and supports __the entire Amazon API__.

![Hoover](https://github.com/papercavalier/sucker/raw/master/hoover.jpg)

Usage
-----

Read the [API](http://aws.amazon.com/archives/Product%20Advertising%20API). Jump to the __Operations__ section if in a hurry.

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

Read further [here](http://rdoc.info/github/papercavalier/sucker/master/frames) and [here](http://relishapp.com/papercavalier/sucker).

API Usage
---------

We have a home-grown collection that helps us manage our (relatively heavy)
use of the Amazon API.

* [Multiplex](http://github.com/papercavalier/multiplex) binds a request
  to a specified local IP.
* [Throttler](http://github.com/papercavalier/throttler) throttles
  requests to a venue to one per second per IP.


A hypothetical setup:

    require 'multiplex'
    require 'throttler'

    ips.each do |ip|
      Thread.new do
        scope = "#{ip}-#{locale}"
        Throttler.throttle(scope) do
          Net::HTTP.bind ip do
            # Set up worker
            response = worker.get
            # Consume response
          end
        end
      end
    end

We prefer to use [Resque](http://github.com/defunkt/resque) to manage
multiple requests.

Generally, four or five workers per locale per IP proves enough to provide
optimum throughput.

Stubbing in Tests
-----------------

Use [VCR](http://github.com/myronmarston/vcr).

Compatibility
-------------

Specs pass against Ruby 1.8.7, Ruby 1.9.2, JRuby 1.5.6, and Rubinius 1.2.1.

Moral of the story
------------------

Don't overabstract a spaghetti API.
