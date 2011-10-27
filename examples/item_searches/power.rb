require File.expand_path('../../helper.rb', __FILE__)

req = Vacuum['us']

req.configure do |c|
  c.key    = AMAZON_KEY
  c.secret = AMAZON_SECRET
  c.tag    = AMAZON_ASSOCIATE_TAG
end

resp = req.search('Books', :power => 'author:lacan and not fiction',
                           :sort  => 'relevancerank')

binding.pry
