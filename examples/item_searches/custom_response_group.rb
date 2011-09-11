require File.expand_path('../../helper.rb', __FILE__)

req = AmazonProduct['us']

req.configure do |c|
  c.key    = YOUR_AMAZON_KEY
  c.secret = YOUR_AMAZON_SECRET
  c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
end

# Run a keyword search on all search indices and use a custom
# response group.
#
# A response group can be a string or an array if you wish to include
# more than one response group.
resp = req.search('Books', :power          => 'Foucault',
                           :response_group => 'Medium')

binding.pry
