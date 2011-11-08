require File.expand_path('../../helper.rb', __FILE__)

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

# Run a keyword search on all search indices and use a custom
# response group.
#
# A response group can be a string or an array if you wish to include
# more than one response group.
res = req.search('Books', :power          => 'Foucault',
                           :response_group => 'Medium')

binding.pry
