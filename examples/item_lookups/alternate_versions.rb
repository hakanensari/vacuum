require File.expand_path('../../helper.rb', __FILE__)

req = Vacuum['us']

req.configure do |c|
  c.key    = AMAZON_KEY
  c.secret = AMAZON_SECRET
  c.tag    = AMAZON_ASSOCIATE_TAG
end

# Look up the alternate versions of an ASIN.
resp = req.find('0679753354', :response_group => 'AlternateVersions')

binding.pry
