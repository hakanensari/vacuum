require File.expand_path('../../helper.rb', __FILE__)

require 'curb'

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
