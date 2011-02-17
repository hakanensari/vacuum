Sucker
======

Sucker is a [Nokogiri-](http://github.com/rails/rails/blob/master/activesupport/lib/active_support/xml_mini/nokogiri.rb)based Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html).

It's fast. It supports __the entire API__.

![Electrolux](https://github.com/papercavalier/sucker/raw/master/electrolux.jpg)

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

Get a response.

    response = worker.get

Consume.

    items = response.find('Item') if response.valid?

Repeat ad infinitum.

[Check the features](http://relishapp.com/papercavalier/sucker).

[Read the API.](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html)

Multiple local IPs
------------------

Amazon limits calls to a venue to one per second per IP. If you have
multiple interfaces set up and want to use all to query Amazon, just do:

    worker.local_ip = '75.80.85.90'
    worker.get # This request will route through the above IP

More concise syntax
-------------------

If you are on Ruby 1.9, try:

    worker << {
      operation: 'ItemLookup',
      id_type:   'ASIN',
      item_id:   '0816614024' }

Stubbing
--------

Use [VCR](http://github.com/myronmarston/vcr).

Check out [this](http://github.com/papercavalier/sucker/blob/master/spec/support/vcr.rb) and [this](https://github.com/papercavalier/sucker/blob/master/features/step_definitions/sucker_steps.rb).

Compatibility
-------------

Specs pass against Ruby 1.8.7, Ruby 1.9.2, and JRuby 1.5.6.

Morale of the story
-------------------

Don't overabstract a spaghetti API.
