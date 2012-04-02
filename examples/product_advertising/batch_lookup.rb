require File.expand_path('../shared.rb', __FILE__)

res   = @req.look_up *Asin.first(20), response_group: 'OfferFull'
items = res.find 'Item'

binding.pry
