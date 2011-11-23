require File.expand_path('../../helper.rb', __FILE__)

require 'httpclient'

module Vacuum
  class Request
    def self.client
      @client ||= HTTPClient.new
    end

    def get
      res = client.get(url.to_s)

      Response.new(res.body, res.code)
    end

    private

    def client
      Request.client
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

all, mutex = {}, Mutex.new

locales.map do |locale|
  Thread.new do
    req = Vacuum.new locale
    res = req.find('0143105825')
    mutex.synchronize { all[locale] = res }
  end
end.each { |thr| thr.join }

binding.pry
