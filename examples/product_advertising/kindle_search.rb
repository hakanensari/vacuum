require File.expand_path('../shared.rb', __FILE__)

# Caveat: Currently there is no way to query Kindle prices other than scraping
# Amazon.
# Alternative strategy: SearchIndex: Books, Power: 'deleuze binding:kindle'
res = @req.search :kindle_store, keywords:       'deleuze',
                                 response_group: 'Large'
items = res.find 'Item'

binding.pry
