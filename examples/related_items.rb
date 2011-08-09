require File.expand_path('../helper.rb', __FILE__)

require 'pp'
require 'amazon_product'

request = AmazonProduct['us']

request.configure do |c|
  c.key    = YOUR_AMAZON_KEY
  c.secret = YOUR_AMAZON_SECRET
  c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
end

request << { :id_type           => 'ASIN',
             :item_id           => '0679753354',
             :response_group    => 'RelatedItems',
             :relationship_type => 'AuthorityTitle' }

response = request.get_item
# A regular item will relate to an authority title.
pp response['RelatedItem']

# An Authority title will relate to one or more regular items.
request << { :item_id => 'B000ASPUES' }
response = request.get
pp response['RelatedItem']
