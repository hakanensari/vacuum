require File.expand_path('../../helper.rb', __FILE__)

locales = Vacuum::Locale::LOCALES

locales.each do |locale|
  Vacuum[locale].configure do |c|
    c.key    = AMAZON_KEY
    c.secret = AMAZON_SECRET
    c.tag    = AMAZON_ASSOCIATE_TAG
  end
end

threads = locales.map do |locale|
  Thread.new do
    req = Vacuum[locale]
    Thread.current[:resp] = req.find('0143105825')
  end
end

resps = threads.map do |thread|
  thread.join
  thread[:resp]
end.flatten

binding.pry
