Sucker
======

Sucker is a minimal Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html). It runs on [cURL](http://github.com/taf2/curb) and [Nokogiri](http://github.com/rails/rails/blob/master/activesupport/lib/active_support/xml_mini/nokogiri.rb). It's fast and supports __the entire API__.

![Electrolux](https://github.com/papercavalier/sucker/raw/master/electrolux.jpg)

Usage
-----

Where's your worker?

    worker = Sucker.new(
      :locale => :us,
      :key    => "API KEY",
      :secret => "API SECRET")

Build a query.

    worker << {
      "Operation"     => "ItemLookup",
      "IdType"        => "ASIN",
      "ItemId"        => some_asins,
      "ResponseGroup" => "ItemAttributes" }

Get a response.

    response = worker.get

Parse.

    items = response.map("Item") do |item|
      # parse
    end

Repeat ad infinitum.

[Check the features](http://relishapp.com/papercavalier/sucker) for more detailed examples.

Read the source code and dive into the [Amazon API docs](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html).

Stubbing
--------

Use [VCR](http://github.com/myronmarston/vcr) to stub your requests.

[This is how my VCR setup looks like](http://github.com/papercavalier/sucker/blob/master/spec/support/vcr.rb).

Compatibility
-------------

Specs pass against Ruby 1.8.7 and Ruby 1.9.2. Sucker has cURL under the hood, so no JRuby.

Afterword
---------

Don't overabstract a spaghetti API.
