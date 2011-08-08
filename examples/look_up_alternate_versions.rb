require 'sucker'

request = Sucker.new(:key    => ENV['AMAZON_KEY'],
                     :secret => ENV['AMAZON_SECRET'],
                     :tag    => ENV['AMAZON_ASSOCIATE_TAG'],
                     :locale => 'us')
request << {
  :operation      => 'ItemLookup',
  :id_type        => 'ASIN',
  :item_id        => '0679753354',
  :response_group => 'AlternateVersions' }

response = request.get
puts response['AlternateVersion']
