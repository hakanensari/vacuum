require File.expand_path('../../helper.rb', __FILE__)

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

res = req.search('Books', :power => 'author:lacan and not fiction',
                          :sort  => 'relevancerank',
                          :response_group => %w{Images ItemAttributes})

binding.pry
