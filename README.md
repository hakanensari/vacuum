Sucker
======

Sucker is a paper-thin Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html). It runs on cURL and Nokogiri and supports __the entire API__.

![Sucker](http://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/FEMA_-_32011_-_FEMA_Joint_Field_Office_%28JFO%29_preparation_in_Ohio.jpg/540px-FEMA_-_32011_-_FEMA_Joint_Field_Office_%28JFO%29_preparation_in_Ohio.jpg)

Examples
--------

Set up a worker.

    worker = Sucker.new(
      :locale         => "us",
      :key            => "API KEY",
      :secret         => "API SECRET")

Optionally, fiddle with curl. Say you want to query Amazon through a different network interface:

    worker.curl { |c| c.interface = "eth1" }

Set up a request.

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
    
Here is the response parsed into a simple hash:

    pp response.to_hash

But you will probably be more interested particular nodes:

       response.node("Item"),
       response.node("Error")

Fetch another ASIN in a more DSL-y way.

    worker << { "ItemId"  => "0486454398" }
    pp worker.get.node("Item")

Check the integration specs for more examples.

Ultimately, you should rely on the API documentation to build your queries.

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

Specs pass against Ruby 1.8.7 and 1.9.2.

Todo
----

* Rip out the Stub class and use VCR instead once Webmock gets a cURL adapter.
