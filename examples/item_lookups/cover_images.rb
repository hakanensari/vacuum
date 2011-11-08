require File.expand_path('../../helper.rb', __FILE__)

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

# Look up cover art for an ASIN.
res = req.find('0394751221', :response_group => 'Images')

binding.pry
