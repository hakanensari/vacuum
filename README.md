Sucker
======

Sucker is a thin Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html). It runs on Curb and Crack and supports __everything__ in the API.

![Sucker](http://upload.wikimedia.org/wikipedia/en/7/71/Vacuum_cleaner_1910.JPG)

Examples
--------

Set up a worker.

    worker = Sucker.new(
      :locale => "us",
      :key    => "API KEY",
      :secret => "API SECRET")

Fiddle with curl.

    worker.curl { |c| c.interface = "eth1" }

Set up a request.

    worker << {
      "Operation" => "ItemLookup",
      "IdType"    => "ASIN",
      "ItemId"    => ["0816614024", "0143105825"] }

Hit Amazon and do something with the response.

    response = worker.get
    p response.code
    p response.time
    p response.body
    
    response.to_h["ItemLookupResponse"]["Items"]["Item"].each { ... }

Hit Amazon again.

    worker << {
      "ItemId"  => 10.more.asins }
    response = worker.get

Check the integration specs for more examples.

Testing
-------

To fake web requests, I do the following:

In a file such as `spec/support/sucker.rb`, I prep:

    require "sucker/stub"
    Sucker.fixtures_path = File.dirname(__FILE__) + "/../fixtures"

In the spec, I set up a worker and then stub it:

    Sucker.stub(@worker)

The first time you run the spec, the worker will perform the actual web request and cache the response. Subsequent requests are then mocked with the cached response.

Specs
-----

The unit specs should run out of the box after you `bundle install`, but the integration specs require you to create [an amazon.yml file with valid credentials](http://github.com/papercavalier/sucker/blob/master/spec/support/amazon.yml.example) in `spec/support`.
