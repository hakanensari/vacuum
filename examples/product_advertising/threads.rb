require File.expand_path('../shared.rb', __FILE__)

results, mutex = {}, Mutex.new
Vacuum::Endpoint::Base::LOCALES.map do |locale|
  Thread.new do
    req = Vacuum.new(:product_advertising) do |config|
      config.locale = locale
      config.key    = KEY
      config.secret = SECRET
      config.tag    = TAG
    end

    req.build 'Operation' => 'ItemLookup',
              'ItemId'    => '0143105825'

    mutex.synchronize { results[locale] = req.get.find('Item') }
  end
end.each(&:join)

binding.pry
