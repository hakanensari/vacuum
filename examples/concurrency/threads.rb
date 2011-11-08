require File.expand_path('../../helper.rb', __FILE__)

locales = Vacuum::Locale::LOCALES

locales.each do |locale|
  Vacuum.configure locale do |c|
    c.key    = KEY
    c.secret = SECRET
    c.tag    = ASSOCIATE_TAG
  end
end

all = {}
mutex = Mutex.new

locales.map do |locale|
  Thread.new do
    req = Vacuum.new locale
    res = req.find('0143105825')
    mutex.synchronize { all[locale] = res }
  end
end.each { |thr| thr.join }

binding.pry
