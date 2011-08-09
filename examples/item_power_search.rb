require File.expand_path('../helper.rb', __FILE__)

require 'pp'
require 'amazon_product'

request = AmazonProduct['us']

request.configure do |c|
  c.key    = YOUR_AMAZON_KEY
  c.secret = YOUR_AMAZON_SECRET
  c.tag    = YOUR_AMAZON_ASSOCIATE_TAG
end

request << { :search_index => 'Books',
             :power        => 'author:lacan and not fiction',
             :sort         => 'relevancerank' }

response = request.search_item
items = response["Item"]
pp items
puts items.size
