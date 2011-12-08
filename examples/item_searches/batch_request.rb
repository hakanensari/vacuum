require File.expand_path('../../helper.rb', __FILE__)

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

query = 'Deleuze and not binding:kindle'
rg = %w{ItemAttributes Images AlternateVersions}
req << { 'Operation'                       => 'ItemSearch',
         'ItemSearch.Shared.SearchIndex'   => 'Books',
         'ItemSearch.Shared.Power'         => query,
         'ItemSearch.Shared.ResponseGroup' => rg,
         'ItemSearch.1.ItemPage'           => 1,
         'ItemSearch.2.ItemPage'           => 2 }
res = req.get

binding.pry
