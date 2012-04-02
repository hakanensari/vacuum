require File.expand_path('../shared.rb', __FILE__)

res = @req.look_up '0816614024', response_group: 'OfferFull',
                                 merchant_id:    'All',
                                 condition:      'All',
                                 version:        '2010-11-01'
items = res.find('Item')

binding.pry
