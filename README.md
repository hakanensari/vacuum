Sucker
======

Sucker is a paper-thin Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html). It runs on cURL and Nokogiri and supports __everything__ in the API.

![Sucker](http://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/FEMA_-_32011_-_FEMA_Joint_Field_Office_%28JFO%29_preparation_in_Ohio.jpg/540px-FEMA_-_32011_-_FEMA_Joint_Field_Office_%28JFO%29_preparation_in_Ohio.jpg)

Examples
--------

Set up a worker.

    worker = Sucker.new(
      :locale         => "us",
      :key            => "API KEY",
      :secret         => "API SECRET")

Fiddle with curl.

    worker.curl { |c| c.interface = "eth1" }

Set up a request.

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
    
Work on the entire document or a particular node.

    pp response.to_hash,
       response.node("Item"),
       response.node("Error")

Have the worker fetch another batch of items in a more DSL-y way.

    worker << { "ItemId"  => another_asin_batch }
    pp worker.get.node("Item")

Check the integration specs for more examples.

Stubbing
--------

To stub web requests in your specs, create `spec/support/sucker_helper.rb`:

    require "sucker/stub"
    
    Sucker.fixtures_path = File.dirname(__FILE__) + "/../fixtures"

In your spec, you can now stub the worker:

    @worker = Sucker.new(some_hash)
    Sucker.stub(@worker)

The first time you run the spec, Sucker will perform the actual request. Following requests will use a cached response.

Compatibility
-------------

Specs pass against Ruby 1.8.7, 1.9.1, 1.9.2, and REE.
