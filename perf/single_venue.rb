require File.expand_path("../bm_helper", __FILE__)
require "throttler"

include Throttler

trap('INT') { exit 0 }

locale    = ARGV[0]
locale    = "us" if locale == ""
local_ip = ARGV[1]

loop do
  asins_fixture.each_slice(20) do |asins|
    Thread.new do
      worker = Sucker.new(
        :locale => locale,
        :key    => amazon["key"],
        :secret => amazon["secret"])
      worker.local_ip = local_ip unless local_ip !~ /\S/
      worker << {
        "Operation"                       => "ItemLookup",
        "ItemLookup.Shared.IdType"        => "ASIN",
        "ItemLookup.Shared.Condition"     => "All",
        "ItemLookup.Shared.MerchantId"    => "All",
        "ItemLookup.Shared.ResponseGroup" => "OfferFull"
      }
      worker << { "ItemLookup.1.ItemId" => asins[0, 10] }
      worker << { "ItemLookup.2.ItemId" => asins[10, 10] }

      throttle("bm") do
        resp = worker.get
        if resp.valid?
          puts "#{Time.now.strftime("%H:%M:%S")} #{resp.time}"
          #puts resp.map("Item") { |item| item["ASIN"] }
        else
          p resp.body
        end
      end
    end
    sleep(1)
  end
end
