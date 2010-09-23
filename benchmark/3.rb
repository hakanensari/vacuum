# Some basic threading with multiple venues. Will use only one ASIN.

require File.expand_path("../../spec/spec_helper", __FILE__)
require "throttler"
include Throttler

pause = 1

asins = ["0816614024"]
  
loop do

  # Since the throttles in the threads do not block this loop, we'd like
  # to hold the horses before firing off the next round of requests
  throttle("foo", pause) do
    %w{us uk de ca fr jp}.each do |locale|
      Thread.new do
        worker = Sucker.new(
          :locale => locale,
          :key    => amazon["key"],
          :secret => amazon["secret"])

        worker << {
          "Operation"     => "ItemLookup",
          "IdType"        => "ASIN",
          "ResponseGroup" => ["ItemAttributes"],
          "ItemId"        => asins }

        throttle("bm#{locale}", pause) do
          resp = worker.get
          resp.node("ItemAttributes").first["ISBN"] rescue puts(resp.body)
          puts "#{Time.now} #{locale}"
        end
      end
    end
  end
end
