require File.expand_path('../shared.rb', __FILE__)

@req.build 'Action'          => 'GetLowestOfferListingsForASIN',
           'ASINList.ASIN.1' => Asin.first
offers = @req.get.find 'GetLowestOfferListingsForASINResult'

binding.pry
