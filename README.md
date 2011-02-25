Sucker
======

Sucker is a Nokogiri-based Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html).

It's minimalist and fast. It supports __the entire API__.

![Electrolux](https://github.com/papercavalier/sucker/raw/master/electrolux.jpg)

Trim fat
--------
1.3.0.pre has major changes under the hood.

Active Support and Curb are no more.

I edited out some nonessential methods. Check [here](http://rdoc.info/github/papercavalier/sucker/master/frames) to see what's left.

Usage
-----

Set up.

    worker = Sucker.new(
      :locale => :us,
      :key    => 'API KEY',
      :secret => 'API SECRET')

Build a request.

    worker << {
      "Operation"     => 'ItemLookup',
      "IdType"        => 'ASIN',
      "ItemId"        => '0816614024',
      "ResponseGroup" => 'ItemAttributes' }

Literally, get a response.

    response = worker.get

Time for some business logic.

    items = response['Item'] if response.valid?

Repeat ad infinitum.

[Check the features](http://relishapp.com/papercavalier/sucker).

[Read the API.](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html)


Monkey-patch that Net::HTTP
---------------------------

Amazon limits calls to a venue to one per second per IP address.

If your server has multiple local interfaces, do the following:

    your_ips.each do |ip|
      Thread.new do
        worker.local_ip = ip
        worker.get
      end
    end

Throttle calls
----------------

Use [Throttler](https://github.com/papercavalier/throttler) to throttle calls to one per second per IP address. Let me know if you figure out a more elegant solution.

More concise syntax
-------------------

If you are on Ruby 1.9, do:

    worker << {
      operation: 'ItemLookup',
      id_type:   'ASIN',
      item_id:   '0816614024' }

Stub
----

Use [VCR](http://github.com/myronmarston/vcr).

Check out [this](http://github.com/papercavalier/sucker/blob/master/spec/support/vcr.rb) and [this](https://github.com/papercavalier/sucker/blob/master/features/step_definitions/sucker_steps.rb).

Compatibility
-------------

Specs pass against Ruby 1.8.7, Ruby 1.9.2, JRuby 1.5.6, and Rubinius 1.2.1.

Morale(s) of the story
-------------------

Don't overabstract a spaghetti API.

Fancy a DSL? Write your own on top of this.
