require File.expand_path('../shared.rb', __FILE__)

@req.build 'Operation'     => 'ItemLookup',
           'MerchantId'    => 'All',
           'Condition'     => 'All',
           'ResponseGroup' => 'OfferFull',
           'ItemId'        => '0816614024',
           'Version'       => '2010-11-01'
items = @req.get.find('Item')

binding.pry
