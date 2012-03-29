require File.expand_path('../shared.rb', __FILE__)
require 'em-synchrony'
require 'em-synchrony/fiber_iterator'

results = {}

EM.synchrony do
  locales = Vacuum::Endpoint::Base::LOCALES

  EM::Synchrony::FiberIterator.new(locales, 10).each do |locale|
    req = Vacuum.new :product_advertising do |config|
      config.locale = locale
      config.key    = KEY
      config.secret = SECRET
      config.tag    = TAG
    end

    req.build 'Operation' => 'ItemLookup',
              'ItemId'    => '0143105825'

    req.connection do |builder|
      builder.adapter :em_synchrony
    end

    results[locale] = req.get.find 'Item'
  end

  EM.stop
end

binding.pry
