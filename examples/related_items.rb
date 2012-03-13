require File.expand_path('../helper.rb', __FILE__)
require 'vacuum'

req = Vacuum.new :key    => KEY,
                 :secret => SECRET,
                 :tag    => TAG

# A regular item will relate to one authority title. An authority title, in
# turn, will relate to one or more regular items.
req.build 'Operation'        => 'ItemLookup',
          'RelationshipType' => 'AuthorityTitle',
          'ResponseGroup'    => 'ItemAttributes,RelatedItems',
          'ItemId'           => 'B000ASPUES'
items = req.get.find 'Item'

binding.pry
