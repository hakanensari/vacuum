require 'bundler/setup'
require 'pry'

require File.expand_path("../../lib/amazon_product", __FILE__)

credentials = YAML::load(File.open(File.expand_path("../credentials.yml", __FILE__)))
AMAZON_KEY           = credentials['key']
AMAZON_SECRET        = credentials['secret']
AMAZON_ASSOCIATE_TAG = credentials['associate_tag']

module Asin
  class << self
    include Enumerable
    def each(&block)
      fixture = File.expand_path('../asins', __FILE__)
      File.new(fixture, 'r').each { |line| yield line.chomp }
    end
  end
end

Pry.hooks[:before_session] = proc { |out, target|
  Pry.run_command "whereami 100", :context => target
}
