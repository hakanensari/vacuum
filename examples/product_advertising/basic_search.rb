require File.expand_path('../shared.rb', __FILE__)

@req.build 'Operation'     => 'ItemSearch',
           'SearchIndex'   => 'Books',
           'Keywords'      => 'deleuze'
items = @req.get.find 'Item'

binding.pry
