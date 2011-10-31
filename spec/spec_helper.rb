require 'rubygems'
require 'bundler/setup'
require 'rspec'

begin
  require 'pry'
rescue LoadError
end

require File.expand_path('../../lib/vacuum', __FILE__)

module Helpers
  def let_req
    let(:req) do
      locale = Vacuum::Locale.new(:us)
      locale.configure do |c|
        c.key    = 'foo'
        c.secret = 'bar'
        c.tag    = 'baz'
      end

      Vacuum::Request.new(locale)
    end
  end
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.extend Helpers
end
