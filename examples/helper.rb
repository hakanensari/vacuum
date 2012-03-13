require 'bundler/setup'
require 'pry'

$:.unshift File.expand_path('../../lib', __FILE__)

credentials_path = File.expand_path('../credentials.yml', __FILE__)
credentials = YAML::load(File.open(credentials_path))

KEY    = credentials['key']
SECRET = credentials['secret']
TAG    = credentials['associate_tag']

# Some ASINs
module Asin
  def self.method_missing(mth, *args, &block)
    File.new(File.expand_path('../asins', __FILE__))
      .map(&:chomp)
      .send(mth, *args, &block)
  end
end

Pry.hooks[:before_session] = proc { |out, target|
  Pry.run_command 'whereami 100', :context => target
}
