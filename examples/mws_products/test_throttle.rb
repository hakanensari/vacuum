require File.expand_path('../shared.rb', __FILE__)
require 'thread'

@req.build action:         'GetLowestOfferListingsForASIN',
           item_condition: 'Used'

now = -> { Time.now.to_f }
count, started_at, _ = 0, now.call, Mutex.new
threads = []
Asin.each_slice(20) do |batch|
  threads << Thread.new do
    last_requested_at = now.call

    @req.build(
      20.times.reduce({}) do |a, i|
        a.merge("ASINList.ASIN.#{i + 1}" => batch[i])
      end
    )
    res = @req.get
    offers = res.find('GetLowestOfferListingsForASINResult')
    if offers.size > 10
      count += 1
      avg = (count / (now.call - started_at)).round 2
      print '.'
    else
      print 'x'
    end
  end

  sleep 0.1
end

threads.each { |thr| thr.join }
