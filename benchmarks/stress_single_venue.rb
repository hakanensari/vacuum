# Stress-test Amazon.com over a single IP

require File.expand_path("../bm_helper", __FILE__)

require "throttler"
include Throttler

start_time = Time.now

calls = {
  :errors     => 0,
  :timestamps => [] }

worker = Sucker.new(
  :locale         => "us",
  :key            => amazon["key"],
  :secret         => amazon["secret"],
  :associate_tag  => amazon["associate_tag"])
worker << {
  "Operation"     => "ItemLookup",
  "IdType"        => "ASIN",
  "ResponseGroup" => ["ItemAttributes"] }

puts "key: #{amazon["key"]}"
puts "associate tag: #{amazon["associate"]}"

asins_fixture.each do |asin|
  worker << { "ItemId" => asin }
  throttle('bm', 1) do
    resp = worker.get
    if resp.valid?
      calls[:timestamps].push(Time.now)
    else
      calls[:errors] += 1
    end
  end

  # Print calls every minute
  total = calls[:timestamps].size + calls[:errors].size
  if total % 30 == 0
    now = Time.now

    recent_timestamps = calls[:timestamps].select { |timestamp| now - timestamp < 60 }
    average = (recent_timestamps.size / 60.0).round(2)
    puts "####{Time.now}###"
    [
      ['Total', 'Errors', 'Average'],
      [total, calls[:errors].size, average]
    ].each do |line|
      puts line.map { |w| w.to_s.ljust(9) }.join(' | ')
    end
  end
end
