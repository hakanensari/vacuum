begin
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end
rescue LoadError
end

require 'rspec'
begin
  require 'pry'
rescue LoadError
end

require 'vacuum'
require 'vacuum/mws'
require 'vacuum/product_advertising'

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end

Dir['./spec/support/**/*.rb'].each { |f| require f }
