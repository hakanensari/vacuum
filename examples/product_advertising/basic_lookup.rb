require File.expand_path('../shared.rb', __FILE__)

@req.build 'Operation' => 'ItemLookup',
           'ItemId'    => '0816614024'
items = @req.get.find 'Item'

binding.pry
