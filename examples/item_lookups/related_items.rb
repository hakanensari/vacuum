require File.expand_path('../../helper.rb', __FILE__)

req = Vacuum['us']

req.configure do |c|
  c.key    = AMAZON_KEY
  c.secret = AMAZON_SECRET
  c.tag    = AMAZON_ASSOCIATE_TAG
end

# A regular item will relate to ONE so-called authority title. An authority
# title, such as the one below, will relate to one or more regular items.
resp = req.find('B000ASPUES', :response_group    => 'RelatedItems',
                              :relationship_type => 'AuthorityTitle')

binding.pry
