require 'rspec'
begin
  require 'pry'
rescue LoadError
end
require 'vacuum/marketplace_web_services'
require 'vacuum/product_advertising'

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end

Dir['./spec/support/**/*.rb'].each { |f| require f }
