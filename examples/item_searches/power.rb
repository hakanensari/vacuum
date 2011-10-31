require File.expand_path('../../helper.rb', __FILE__)

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

resp = req.search('Books', :power => 'author:lacan and not fiction',
                           :sort  => 'relevancerank')

binding.pry
