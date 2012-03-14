require File.expand_path('../helper.rb', __FILE__)
require 'vacuum/em'

EM.run do
  EM::Iterator.new(Vacuum::Request::HOSTS.keys, 10).map(
    proc { |locale, iter|
      req = Vacuum.new :locale => locale,
                       :key    => KEY,
                       :secret => SECRET,
                       :tag    => TAG

      req.build 'Operation' => 'ItemLookup',
                'ItemId'    => '0143105825'

      err = ->(http) { raise http.error }
      req.aget(err) do |res|
        iter.return({ locale => res })
      end
    }, proc { |all|
      all = all.inject({}) { |a, res| a.merge(res) }
      binding.pry
      EM.stop
    })
end
