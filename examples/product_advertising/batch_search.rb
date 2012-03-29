require File.expand_path('../shared.rb', __FILE__)

rg = %w{ItemAttributes Images AlternateVersions}
@req.build 'Operation'                       => 'ItemSearch',
           'ItemSearch.Shared.SearchIndex'   => 'Books',
           'ItemSearch.Shared.Power'         => 'Deleuze',
           'ItemSearch.Shared.ResponseGroup' => rg,
           'ItemSearch.1.ItemPage'           => 1,
           'ItemSearch.2.ItemPage'           => 2
items = @req.get.find 'Item'

binding.pry
