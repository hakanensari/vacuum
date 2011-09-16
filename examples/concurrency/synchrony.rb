require File.expand_path('../../helper.rb', __FILE__)

AmazonProduct::Request.adapter = :synchrony

req = AmazonProduct['us']

req.configure do |c|
  c.key    = AMAZON_KEY
  c.secret = AMAZON_SECRET
  c.tag    = AMAZON_ASSOCIATE_TAG
end

resp = nil
EM.synchrony do
  resp = req.find('0816614024')
  EM.stop
  resp
end

binding.pry
