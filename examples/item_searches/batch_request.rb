require File.expand_path('../../helper.rb', __FILE__)

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

req << { 'Operation'                       => 'ItemSearch',
         'ItemSearch.Shared.SearchIndex'   => 'Books',
         'ItemSearch.Shared.Keywords'      => 'Deleuze',
         'ItemSearch.1.ItemPage'           => 1,
         'ItemSearch.2.ItemPage'           => 2 }
res = req.get

binding.pry
