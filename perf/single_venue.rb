require 'ruby-debug'
require File.expand_path('../helper', __FILE__)

trap('INT') { exit 0 }

locale = ARGV[0] || :us

loop do
  asins_fixture.each_slice(20) do |asins|
    Thread.new do
      worker = Sucker.new(
        :locale => locale,
        :key    => amazon['key'],
        :secret => amazon['secret'])
      worker << {
        'Operation'                       => 'ItemLookup',
        'ItemLookup.Shared.IdType'        => 'ASIN',
        'ItemLookup.Shared.Condition'     => 'All',
        'ItemLookup.Shared.MerchantId'    => 'All',
        'ItemLookup.Shared.ResponseGroup' => 'OfferFull'
      }
      worker << { 'ItemLookup.1.ItemId' => asins[0, 10] }
      worker << { 'ItemLookup.2.ItemId' => asins[10, 10] }

      resp = worker.get
      if resp.valid?
        puts "#{Time.now.strftime("%H:%M:%S")}"
      else
        puts resp.body, resp.to_hash
      end
    end

    sleep(0.1)
  end
end
