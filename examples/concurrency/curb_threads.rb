require File.expand_path('../../helper.rb', __FILE__)

require 'curb'

# Monkey-patch request to use Curb
module Vacuum
  class Request
    def get
      http = Curl::Easy.perform(url.to_s)

      Response.new(http.body_str, http.response_code)
    end
  end
end

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
    Thread.current[:resp] = { locale => req.find('0143105825') }
  end
end

resps = threads.map do |thread|
  thread.join
  thread[:resp]
end.flatten

resps = resps.inject({}) { |a, resp| a.merge(resp) }

binding.pry
