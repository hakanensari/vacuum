require File.expand_path('../../helper.rb', __FILE__)

in_your_shell do
  AmazonProduct::Request.adapter = :curb

  locales = AmazonProduct::Locale::LOCALES

  locales.each do |locale|
    AmazonProduct[locale].configure do |c|
      c.key    = YOUR_AMAZON_KEY
      c.secret = YOUR_AMAZON_SECRET
      c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
    end
  end

  threads = locales.map do |locale|
    Thread.new do
      req = AmazonProduct[locale]
      Thread.current[:resp] = req.find('0143105825')
    end
  end

  threads.map do |thread|
    thread.join
    thread[:resp]
  end.flatten
end
