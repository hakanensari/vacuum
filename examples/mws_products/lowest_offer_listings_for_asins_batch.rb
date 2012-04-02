require File.expand_path('../shared.rb', __FILE__)

@req.build(
  20.times.reduce({}) do |a, i|
    a.merge("ASINList.ASIN.#{i + 1}" => Asin[i])
  end
)
@req.build action:         'GetLowestOfferListingsForASIN',
           item_condition: 'Used'
offers = @req.get.find 'GetLowestOfferListingsForASINResult'

binding.pry
