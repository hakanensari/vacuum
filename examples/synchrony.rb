require File.expand_path('../helper.rb', __FILE__)

require 'pp'
require 'amazon_product/synchrony'

request = AmazonProduct['us']

request.configure do |c|
  c.key    = YOUR_AMAZON_KEY
  c.secret = YOUR_AMAZON_SECRET
  c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
end

request << { :id_type => 'ASIN',
             :item_id => '0816614024' }

EM.synchrony do
  response = request.get_item
  pp response['Item']
  EM.stop
end
