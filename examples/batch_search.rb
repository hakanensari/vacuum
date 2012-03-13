require File.expand_path('../helper.rb', __FILE__)
require 'vacuum'

req = Vacuum.new :key    => KEY,
                 :secret => SECRET,
                 :tag    => TAG

rg = %w{ItemAttributes Images AlternateVersions}
req.build 'Operation'                       => 'ItemSearch',
          'ItemSearch.Shared.SearchIndex'   => 'Books',
          'ItemSearch.Shared.Power'         => 'Deleuze',
          'ItemSearch.Shared.ResponseGroup' => rg,
          'ItemSearch.1.ItemPage'           => 1,
          'ItemSearch.2.ItemPage'           => 2
items = req.get.find 'Item'

binding.pry
