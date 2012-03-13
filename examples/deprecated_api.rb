require File.expand_path('../helper.rb', __FILE__)
require 'vacuum'

req = Vacuum.new :key    => KEY,
                 :secret => SECRET,
                 :tag    => TAG
req.build 'Operation'     => 'ItemLookup',
          'MerchantId'    => 'All',
          'Condition'     => 'All',
          'ResponseGroup' => 'OfferFull',
          'ItemId'        => '0816614024',
          'Version'       => '2010-11-01'
items = req.get.find('Item')

binding.pry
