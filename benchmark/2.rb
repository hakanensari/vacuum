# Another regular loop, but this time we're creating a new instance of Sucker
# each time we fire off a request.
#
# This is closer to a use case where each batch is an independent job in, say,
# a Resque queue.

pause = 1

require File.expand_path("../../spec/spec_helper", __FILE__)
require "throttler"

include Throttler

asins = %w{
  0816614024 0143105825 0485113600 0816616779 0942299078
  1844674282 0745640974 0745646441 0826489540 1844672972 }
  
loop do
  worker = Sucker.new(
    :locale => "us",
    :key    => amazon["key"],
    :secret => amazon["secret"])

  worker << {
    "Operation"     => "ItemLookup",
    "IdType"        => "ASIN",
    "ResponseGroup" => ["ItemAttributes"],
    "ItemId"        => asins }

  throttle("bm", pause) do
    resp = worker.get
    resp.node("ItemAttributes").first["ISBN"] rescue puts(resp.body)
    puts Time.now
  end
end
