require 'rubygems'
require 'bundler/setup'
require 'ruby-debug'
require 'sucker'

module SuckerMethods
  def amazon
    YAML::load_file(File.dirname(__FILE__) + "/../../spec/support/amazon.yml")
  end
end

World(SuckerMethods)
