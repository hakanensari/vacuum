require File.expand_path('../helper.rb', __FILE__)
require 'vacuum'

all, mutex = {}, Mutex.new
Vacuum::Request::HOSTS.keys.map do |locale|
  Thread.new do
    req = Vacuum.new :locale => locale,
                     :key    => KEY,
                     :secret => SECRET,
                     :tag    => TAG

    req.build 'Operation' => 'ItemLookup',
              'ItemId'    => '0143105825'

    mutex.synchronize { all[locale] = req.get.find('Item') }
  end
end.each(&:join)

binding.pry
