# Seems Amazon is more lenient when only queried with one ASIN?

pause = 0.1

require File.expand_path("../../spec/spec_helper", __FILE__)
require "throttler"

include Throttler

asins = "0816614024"

worker = Sucker.new(
  :locale => "us",
  :key    => amazon["key"],
  :secret => amazon["secret"])

worker << {
  "Operation"     => "ItemLookup",
  "IdType"        => "ASIN",
  "ResponseGroup" => ["RelatedItems"],
  "RelationshipType"  => "AuthorityTitle",
  "ItemId"        => asins }

loop do
  throttle("foo", pause) do
    Thread.new do
      throttle("bm", pause) do
        resp = worker.get
        resp.node("RelatedItems").first["ISBN"] rescue puts(resp.body)
        puts Time.now
      end
    end
  end
end
