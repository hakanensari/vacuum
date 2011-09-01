require File.expand_path('../../helper.rb', __FILE__)

req = AmazonProduct['us']

req.configure do |c|
  c.key    = YOUR_AMAZON_KEY
  c.secret = YOUR_AMAZON_SECRET
  c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
end

resp = req.search('Books', :power => 'author:lacan and not fiction',
                           :sort  => 'relevancerank')

binding.pry
