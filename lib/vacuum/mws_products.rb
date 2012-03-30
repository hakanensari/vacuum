require 'vacuum'

%w(endpoint).each do |path|
  require "vacuum/#{path}/mws"
  require "vacuum/#{path}/mws_products"
end

module Vacuum
  class MissingMarketplace < ArgumentError; end
  class MissingSeller      < ArgumentError; end
end
