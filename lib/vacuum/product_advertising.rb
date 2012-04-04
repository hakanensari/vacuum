%w(endpoint request response).each do |path|
  require "vacuum/#{path}/product_advertising"
end

module Vacuum
  MissingTag = Class.new(ArgumentError)
end
