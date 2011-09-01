require File.expand_path('../../helper.rb', __FILE__)

req = AmazonProduct['us']

req.configure do |c|
  c.key    = YOUR_AMAZON_KEY
  c.secret = YOUR_AMAZON_SECRET
  c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
end

# A regular item will relate to ONE so-called authority title. An authority
# title, such as the one below, will relate to one or more regular items.
resp = req.find('B000ASPUES', :response_group    => 'RelatedItems',
                              :relationship_type => 'AuthorityTitle')

binding.pry
