Sucker
======

Sucker is a Nokogiri-based Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html).

Sucker is fast and supports __the entire Amazon API__.

![Hoover](https://github.com/papercavalier/sucker/raw/master/hoover.jpg)

Usage
-----

Set up.

    worker = Sucker.new(
      :locale => :us,
      :key    => 'API KEY',
      :secret => 'API SECRET')

Build a request.

    worker << {
      'Operation'     => 'ItemLookup',
      'IdType'        => 'ASIN',
      'ItemId'        => '0816614024',
      'ResponseGroup' => 'ItemAttributes' }

Get a response.

    response = worker.get

Do something with it.

    items = response['Item'] if response.valid? # and so on

Repeat ad infinitum.

Read [the Sucker API](http://rdoc.info/github/papercavalier/sucker/master/frames).

Multiple IPs
------------

Amazon limits calls to a venue to one per second per IP address.

If your server has multiple local interfaces, use them simultaneously like so:

    your_ips.each do |ip|
      Thread.new do
        worker.local_ip = ip
        worker.get
      end
    end

Stubbing in Tests
-----------------

Use [VCR](http://github.com/myronmarston/vcr).

Compatibility
-------------

Specs pass against Ruby 1.8.7, Ruby 1.9.2, JRuby 1.5.6, and Rubinius 1.2.1.

Moral of the story
------------------

Don't overabstract a spaghetti API.
