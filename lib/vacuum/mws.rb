%w(endpoint request response).each do |path|
  require "vacuum/#{path}/mws"
end

module Vacuum
  class MissingMarketplace < ArgumentError; end
  class MissingSeller      < ArgumentError; end
end
