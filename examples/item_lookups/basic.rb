require File.expand_path('../../helper.rb', __FILE__)

Vacuum.configure :us do |c|
  c.key    = KEY
  c.secret = SECRET
  c.tag    = ASSOCIATE_TAG
end
req = Vacuum.new :us

req << {
  'Operation' => 'ItemLookup',
  'ItemId'    => '0816614024'
}

res = req.get

binding.pry
