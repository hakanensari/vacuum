require File.expand_path('../../helper.rb', __FILE__)

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

# One interesting note: Kind books do not return an offers response group.
# Currently, there is no way to query Amazon's sale price other than scraping
# their website.

# An alternative way to search for Kindle books:
# req.search('Books', :power => 'deleuze binding:kindle')

req.search('KindleStore', 'deleuze')

binding.pry
