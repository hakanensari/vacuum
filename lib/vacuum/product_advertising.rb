%w(endpoint request response).each do |path|
  require "vacuum/#{path}/product_advertising"
end

module Vacuum
  class MissingTag < ArgumentError; end
end
