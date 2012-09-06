$:.unshift File.expand_path('../../lib', __FILE__)

require 'pry'
require 'yaml'
require 'vacuum'

req = Vacuum.new
req.configure YAML.load_file File.expand_path '../amazon.yml', __FILE__

res = req.get query: { 'Operation'   => 'ItemSearch',
                       'SearchIndex' => 'Books',
                       'Keywords'    => 'Architecture' }
binding.pry
