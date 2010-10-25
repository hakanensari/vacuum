Sucker
======

Sucker is a Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html). It runs on [curb](http://github.com/taf2/curb) and [the Nokogiri implementation of the XML Mini module](http://github.com/rails/rails/blob/master/activesupport/lib/active_support/xml_mini/nokogiri.rb) in Active Support. It's fast and supports __the entire API__.

![Sucker](http://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/FEMA_-_32011_-_FEMA_Joint_Field_Office_%28JFO%29_preparation_in_Ohio.jpg/480px-FEMA_-_32011_-_FEMA_Joint_Field_Office_%28JFO%29_preparation_in_Ohio.jpg)

Examples
--------

Set up a worker.

    worker = Sucker.new(
      :locale => "us",
      :key    => "API KEY",
      :secret => "API SECRET")

Prepare a request.

    asin_batch = %w{
      0816614024 0143105825 0485113600 0816616779 0942299078
      0816614008 144006654X 0486400360 0486417670 087220474X }
    worker << {
      "Operation"     => "ItemLookup",
      "IdType"        => "ASIN",
      "ItemId"        => asin_batch,
      "ResponseGroup" => ["ItemAttributes", "OfferFull"] }

Perform the request.

    response = worker.get

Debug.

    p response.valid?,
      response.code,
      response.time,
      response.body,
      response.xml,
      response.to_hash

Iterate over items in your item lookup.

    response.find("Item")  { |item| ... }

Iterate over errors.

    response.find("Error") { |error| ... }

Repeat ad infinitum.

Check my [integration specs](http://github.com/papercavalier/sucker/tree/master/spec/integration/) for more examples. See [twenty items](http://github.com/papercavalier/sucker/tree/master/spec/integration/twenty_items_spec.rb) and [multiple locales](http://github.com/papercavalier/sucker/tree/master/spec/integration/multiple_locales_spec.rb) for relatively advanced usage.

Last but not least, dive into the [API docs](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html) to construct your own queries.

Stubbing
--------

Use [VCR](http://github.com/myronmarston/vcr) to stub your requests.

Caveat: Match URIs on host only and create a new cassette for each stubbed query. [This is how I do it](http://github.com/papercavalier/sucker/blob/master/spec/support/vcr.rb).

Compatibility
-------------

Specs pass against Ruby 1.8.7, Ruby 1.9.2, and Rubinius 1.1.
