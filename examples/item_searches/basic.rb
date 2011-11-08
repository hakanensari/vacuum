require File.expand_path('../../helper.rb', __FILE__)

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

# Run a keyword search on all search indices.
res = req.search('George Orwell')

binding.pry
