require 'bundler/setup'
require 'pry'

require File.expand_path("../../lib/vacuum", __FILE__)

credentials = YAML::load(File.open(File.expand_path("../credentials.yml", __FILE__)))
AMAZON_KEY           = credentials['key']
AMAZON_SECRET        = credentials['secret']
AMAZON_ASSOCIATE_TAG = credentials['associate_tag']

# Some ASINs.
module Asin
  class << self
    def method_missing(mth, *args, &block)
      (@asins ||=
        File.new(File.expand_path('../asins', __FILE__), 'r').
        map(&:chomp)).
        send(mth, *args, &block)
    end
  end
end

Pry.hooks[:before_session] = proc { |out, target|
  Pry.run_command "whereami 100", :context => target
}
