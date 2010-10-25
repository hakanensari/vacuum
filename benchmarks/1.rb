# A regular loop that reuses the same worker instance. This is the simplest
# use case.

pause = 1.0

require File.expand_path("../../spec/spec_helper", __FILE__)
require "throttler"

include Throttler

asins = %w{
  0816614024 0143105825 0485113600 0816616779 0942299078
  1844674282 0745640974 0745646441 0826489540 1844672972 }

worker = Sucker.new(
  :locale => "us",
  :key    => amazon["key"],
  :secret => amazon["secret"])

worker << {
  "Operation"     => "ItemLookup",
  "IdType"        => "ASIN",
  "ResponseGroup" => ["ItemAttributes"],
  "ItemId"        => asins }

loop do
  throttle("bm", pause) do
    resp = worker.get
    resp.find("ItemAttributes").first["ISBN"] rescue puts(resp.body)
    puts Time.now
  end
end
