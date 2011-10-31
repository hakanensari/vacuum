require File.expand_path('../../helper.rb', __FILE__)

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

# The latest API returns only the lowest-priced offers for each
# condition and deprecates some important offer attributes.
resp1 = req.find('0816614024', :condition      => 'All',
                               :response_group => 'OfferFull')

# Lock version to `2010-11-10`.
resp2 = req.find('0816614024', :version        => '2010-11-01',
                               :merchant_id    => 'All',
                               :condition      => 'All',
                               :response_group => 'OfferFull')

binding.pry
