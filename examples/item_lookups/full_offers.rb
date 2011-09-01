require File.expand_path('../../helper.rb', __FILE__)

req = AmazonProduct['us']

req.configure do |c|
  c.key    = YOUR_AMAZON_KEY
  c.secret = YOUR_AMAZON_SECRET
  c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
end

# We lock our version to `2010-11-10` because the latest API version returns
# only the lowest-priced offers for each condition and deprecates some
# important offer attributes.
resp = req.find('0816614024', :version        => '2010-11-01',
                              :merchant_id    => 'All',
                              :condition      => 'All',
                              :response_group => ['OfferFull', 'ItemAttributes'])

binding.pry
