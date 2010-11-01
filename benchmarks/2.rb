# Another regular loop, but this time we're creating a new instance of Sucker
# each time we fire off a request.
#
# This is closer to a use case where each batch is an independent job in, say,
# a Resque queue.

pause = 1

require File.expand_path("../bm_helper", __FILE__)

require "throttler"
include Throttler

loop do
  start = Time.now.to_i
  asins_fixture.each_slice(10) do |batch|
    worker = Sucker.new(
      :locale => "us",
      :key    => amazon["key"],
      :secret => amazon["secret"])

    worker << {
      "Operation"     => "ItemLookup",
      "IdType"        => "ASIN",
      "ResponseGroup" => ["ItemAttributes"],
      "ItemId"        => batch }

    throttle("bm", pause) do
      resp = worker.get
      resp.find("ItemAttributes").first["ISBN"] rescue puts(resp.body)
      puts Time.now
    end
  end
  puts "1000 ASINs in #{(Time.now.to_i - start)}"
end
