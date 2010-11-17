Sucker
======

Sucker is a minimal Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html). It runs on [curb](http://github.com/taf2/curb) and [the Nokogiri implementation of the XML Mini module](http://github.com/rails/rails/blob/master/activesupport/lib/active_support/xml_mini/nokogiri.rb) in Active Support. It's fast and supports __the entire API__.

![Electrolux](https://github.com/papercavalier/sucker/raw/master/electrolux.jpg)

Usage
-----

Set up a worker.

    worker = Sucker.new(
      :locale => "us",
      :key    => "API KEY",
      :secret => "API SECRET")

Prepare a request.

    worker << {
      "Operation"     => "ItemLookup",
      "IdType"        => "ASIN",
      "ItemId"        => some_asins,
      "ResponseGroup" => "ItemAttributes" }

Get a response.

    response = worker.get

Make sure nothing went [awry](http://gloss.papercavalier.com/2010/11/01/amazon-call-throttling-demystified.html).

    response.valid?

Now parse it.

    items = response.map("Item") do |item|
      # parse item
    end

Repeat ad infinitum.

[Check my integration specs](http://github.com/papercavalier/sucker/tree/master/spec/integration/) for more detailed examples. See [twenty items](http://github.com/papercavalier/sucker/tree/master/spec/integration/twenty_items_spec.rb) and [multiple locales](http://github.com/papercavalier/sucker/tree/master/spec/integration/multiple_locales_spec.rb) for relatively advanced usage.

Read the source code and dive into the [Amazon API docs](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html).

Stubbing
--------

Use [VCR](http://github.com/myronmarston/vcr) to stub your requests.

Match URIs on host only and create a new cassette for each query. [This is how my VCR setup looks like](http://github.com/papercavalier/sucker/blob/master/spec/support/vcr.rb).

Compatibility
-------------

Specs pass against Ruby 1.8.7 and Ruby 1.9.2.

Sucker works seamlessly with or without Rails.

Sucker won't work on JRuby. (We got Curl under the hood. It's worth the trade-off.)

Afterword
---------

No DSL. No object mapping. Pure Nokogiri goodness.
