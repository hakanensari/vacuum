Sucker
======

Sucker is a Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html). It runs on cURL and the Nokogiri implementation of the XML Mini module in Active Support. It is blazing fast and supports __the entire API__.

![Sucker](http://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/FEMA_-_32011_-_FEMA_Joint_Field_Office_%28JFO%29_preparation_in_Ohio.jpg/540px-FEMA_-_32011_-_FEMA_Joint_Field_Office_%28JFO%29_preparation_in_Ohio.jpg)

Examples
--------

Set up a worker.

    worker = Sucker.new(
      :locale         => "us",
      :key            => "API KEY",
      :secret         => "API SECRET")

Optionally, fiddle with cURL. Say you want to query Amazon through a different network interface:

    worker.curl { |c| c.interface = "eth0:0" }

Now, set up a request.

    asin_batch = %w{
      0816614024 0143105825 0485113600 0816616779 0942299078
      0816614008 144006654X 0486400360 0486417670 087220474X }
    worker << {
      "Operation"     => "ItemLookup",
      "IdType"        => "ASIN",
      "ItemId"        => asin_batch,
      "ResponseGroup" => ["ItemAttributes", "OfferFull"] }

Hit Amazon.

    response = worker.get

View the internals of the response object.

    p response.code,
      response.time,
      response.body,
      response.xml

Confirm response is valid.

    response.valid?

Cast response as a hash:

    pp response.to_hash

Grab a node:

       response.node("Item"),
       response.node("Error")

Fetch another ASIN in a more DSL-y way.

    worker << { "ItemId"  => "0486454398" }
    pp worker.get.node("Item")

Repeat ad infinitum.

Check the [integration specs](http://github.com/papercavalier/sucker/tree/master/spec/integration/) for more examples and then dive into the [API docs](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html).

Stubbing
--------

Use [VCR](http://github.com/myronmarston/vcr) to stub your requests. [This file](http://github.com/papercavalier/sucker/blob/master/spec/support/vcr.rb) should help you set up VCR with RSpec.

Don't match requests on URI. The parameters include a timestamp, so each URI is unique.

Compatibility
-------------

Specs pass against Ruby 1.8.7 and 1.9.2.
