unless defined?(Bundler)
  require "rubygems"
  require "bundler/setup"
end

require File.expand_path("../../lib/sucker", __FILE__)

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each{ |f| require f }
