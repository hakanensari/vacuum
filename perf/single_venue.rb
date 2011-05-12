require 'ruby-debug'
require File.expand_path('../helper', __FILE__)

trap('INT') { exit 0 }

locale = ARGV[0] || :us

loop do
  asins_fixture.each_slice(20) do |asins|
    Thread.new do
      request = Sucker.new(
        :locale => locale,
        :key    => amazon['key'],
        :secret => amazon['secret'])
      request << {
        'Operation'                       => 'ItemLookup',
        'ItemLookup.Shared.IdType'        => 'ASIN',
        'ItemLookup.Shared.Condition'     => 'All',
        'ItemLookup.Shared.MerchantId'    => 'All',
        'ItemLookup.Shared.ResponseGroup' => 'OfferFull'
      }
      request << { 'ItemLookup.1.ItemId' => asins[0, 10] }
      request << { 'ItemLookup.2.ItemId' => asins[10, 10] }

      resp = request.get
      if resp.valid?
        puts "#{Time.now.strftime("%H:%M:%S")}"
      else
        puts resp.body, resp.errors
      end
    end

    sleep(1)
  end
end
