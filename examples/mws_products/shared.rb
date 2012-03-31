require 'bundler/setup'
require 'pry'
require 'vacuum'

$:.unshift File.expand_path('../../lib', __FILE__)

credentials_path = File.expand_path('../credentials.yml', __FILE__)
credentials = YAML::load(File.open(credentials_path))

KEY         = credentials['key']
LOCALE      = credentials['locale']
MARKETPLACE = credentials['marketplace']
SECRET      = credentials['secret']
SELLER      = credentials['seller']

# Some ASINs
module Asin
  def self.method_missing(mth, *args, &block)
    File.new(File.expand_path('../../asins', __FILE__))
      .map(&:chomp)
      .send(mth, *args, &block)
  end
end

@req = Vacuum.new(:mws_products) do |config|
  config.key         = KEY
  config.locale      = LOCALE
  config.marketplace = MARKETPLACE
  config.secret      = SECRET
  config.seller      = SELLER
end
