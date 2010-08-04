Sucker
======

Sucker is a paper-thin Ruby wrapper to the [Amazon Product Advertising API](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html). It runs on cURL and Nokogiri and supports __everything__ in the API.

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
      "ItemId"    => asin_batch

Hit Amazon and do something with the response.

    response = worker.get
    p response.code
    p response.time
    p response.body
    
    response.to_h["ItemLookupResponse"]["Items"]["Item"].each { ... }

Hit Amazon again.

    worker << { "ItemId"  => another_asin_batch }
    response = worker.get

Check the integration specs for more examples.

Testing
-------

To fake web requests, create `spec/support/sucker.rb` and:

    require "sucker/stub"
    Sucker.fixtures_path = File.dirname(__FILE__) + "/../fixtures"

Then, in your spec, stub the worker:

    @worker = Sucker.new(some_hash)
    Sucker.stub(@worker)

The first time you run the spec, Sucker will perform the actual web request and cache the response. Then, it will stub subsequent requests with the cached response.

Notes
-----

* The unit specs should run out of the box after you `bundle install`, but the integration specs require you to create [an amazon.yml file with valid credentials](http://github.com/papercavalier/sucker/blob/master/spec/support/amazon.yml.example) in `spec/support`.

* Version 0.6.0 now has Active Support's Nokogiri-based `to_hash` under the hood. After some meddling, it does what it's supposed to do and is blazing fast. Fix up your code accordingly.

* To test specs against all rubies on your system , run `./rake_rubies.sh spec:progress`.
