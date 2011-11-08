require File.expand_path('../../helper.rb', __FILE__)

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

# A regular item will relate to ONE so-called authority title. An
# authority title, such as the one below, will relate to one or more
# regular items.
res = req.find('B000ASPUES', :response_group    => 'RelatedItems',
                              :relationship_type => 'AuthorityTitle')

binding.pry
