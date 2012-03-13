require 'rubygems'
require 'bundler/setup'
require 'rspec'

begin
  require 'pry'
rescue LoadError
end

require File.expand_path('../../lib/vacuum', __FILE__)

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end
