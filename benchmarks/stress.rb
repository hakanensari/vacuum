# Stress-test Amazons over a single IP

# So we print average of last x seconds
frequency = 60

require File.expand_path("../bm_helper", __FILE__)

require "throttler"
include Throttler

locales = %w{us uk de ca fr jp}
pause = 1
calls = {}
start_time = Time.now
count = 0

asins_fixture.each_slice(10) do |asins|
  threads = locales.map do |locale|

    # Initialize counter
    calls[locale] ||= {
      'total'      => 0,
      'errors'     => 0,
      'timestamps' => [] }

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
        Thread.current[:locale] = locale
        Thread.current[:timestamp] = Time.now if resp.valid?
      end
    end
  end

  threads.map do |thread|
    next unless thread.join(3)

    locale    = thread[:locale]
    timestamp = thread[:timestamp]
    if timestamp
      calls[locale]['total'] += 1
      calls[locale]['timestamps'].push(Time.now)
    else
      calls[locale]['errors'] += 1
    end
  end

  # Print calls every minute
  if (count += 1) % frequency == 0
    locales.each do |locale|
      total = calls[locale]['total']
      errors = calls[locale]['errors']
      now = Time.now
      timestamps = calls[locale]['timestamps'].select { |timestamp| now - timestamp < frequency }
      calls[locale]['timestamps'] = timestamps
      average = (timestamps.size / frequency.to_f).round(2)
      [
        [locale, 'Total', 'Errors', 'Average'],
        ['', total, errors, average]
      ].each do |line|
        puts line.map { |w| w.to_s.ljust(9) }.join(' | ')
      end
    end

    puts "[#{Time.now}]"
    puts '-' * 46
  end
end
