require File.expand_path('../../helper.rb', __FILE__)

locales = Vacuum::Locale::LOCALES

locales.each do |locale|
  Vacuum.configure locale do |c|
    c.key    = KEY
    c.secret = SECRET
    c.tag    = ASSOCIATE_TAG
  end
end

threads = locales.map do |locale|
  Thread.new do
    req = Vacuum.new locale
    Thread.current[:resp] = { locale => req.find('0143105825') }
  end
end

resps = threads.map do |thread|
  thread.join
  thread[:resp]
end.flatten

resps = resps.inject({}) { |a, resp| a.merge(resp) }

binding.pry
