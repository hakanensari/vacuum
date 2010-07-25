Sucker
======

Sucker is a thin Ruby wrapper to the Amazon Product Advertising API. It runs on Curb and Crack.

![Sucker](http://upload.wikimedia.org/wikipedia/en/7/71/Vacuum_cleaner_1910.JPG)

Examples
--------

Set up a worker.

    @worker = Sucker.new(
      :locale => "us",
      :key    => "API KEY",
      :secret => "API SECRET")

Fiddle with curl.

    @worker.curl { |c| c.interface = "eth1" }

Set up a request.

    @worker << {
      "Operation" => "ItemLookup",
      "IdType"    => "ASIN",
      "ItemId"    => ["0816614024", "0143105825"] }

Hit Amazon and do something with the response.

    pp @worker.get["ItemLookupResponse"]["Items"]["Item"]

Hit Amazon again.

    @worker << {
      "ItemId"  => ["0393329259", "0393317757"] }
    @worker.get

Check the integration specs for some more examples.
