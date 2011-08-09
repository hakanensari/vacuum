require File.expand_path('../helper.rb', __FILE__)

require 'pp'
require 'amazon_product'

request = AmazonProduct['us']

request.configure do |c|
  c.key    = YOUR_AMAZON_KEY
  c.secret = YOUR_AMAZON_SECRET
  c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
end

request << {
  :search_index   => 'Books',
  :power          => 'deleuze binding:kindle',
  :response_group => 'ItemAttributes, Offers' }

response = request.search_item
items = response["Item"]
pp items

# Search for a Kindle edition using the `KindleStore` search index
request.reset
request << {
  :search_index   => 'KindleStore',
  :keywords       => 'deleuze',
  :response_group => 'ItemAttributes, Offers' }

response = request.search_item
items = response["Item"]
pp items
