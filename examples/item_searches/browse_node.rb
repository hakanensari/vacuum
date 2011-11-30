require File.expand_path('../../helper.rb', __FILE__)

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

res = req.search('Electronics', :browse_node    => 172500,
                                :keywords       => 'MB138LL/A',
                                :response_group => %w{Small Offers})

binding.pry
