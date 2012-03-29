require File.expand_path('../shared.rb', __FILE__)

# Caveat: Currently there is no way to query Kindle prices other than scraping
# Amazon.
# Alternative strategy: SearchIndex: Books, Power: 'deleuze binding:kindle'
@req.build 'Operation'     => 'ItemSearch',
           'SearchIndex'   => 'KindleStore',
           'Keywords'      => 'deleuze',
           'ResponseGroup' => 'Large'
items = @req.get.find 'Item'

binding.pry
