require "rubygems"
require "bundler"
Bundler.require(:default)

require File.expand_path("../../lib/sucker", __FILE__)

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each{ |f| require f }
