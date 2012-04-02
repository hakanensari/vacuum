require File.expand_path('../shared.rb', __FILE__)

res, mutex = {}, Mutex.new
Vacuum::Endpoint::Base::LOCALES.map do |locale|
  Thread.new do
    req = Vacuum.new(:product_advertising) do |config|
      config.locale = locale
      config.key    = KEY
      config.secret = SECRET
      config.tag    = TAG
    end

    mutex.synchronize { res[locale] = req.look_up('0143105825').find('Item') }
  end
end.each(&:join)

binding.pry
