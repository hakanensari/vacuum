require File.expand_path('../../helper.rb', __FILE__)

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

# Look up the alternate versions of an ASIN.
resp = req.find('0679753354', :response_group => 'AlternateVersions')

binding.pry
