# frozen_string_literal: true

require 'forwardable'
require 'vacuum/request'
require 'vacuum/version'

# Vacuum is a Ruby wrapper to the Amazon Product Advertising API.
module Vacuum
  class << self
    extend Forwardable

    def_delegator Vacuum::Request, :new
  end

  Market = Struct.new(:host, :region) do
    def site
      host.sub('webservices', 'www')
    end

    def endpoint(operation)
      "https://#{host}/paapi5/#{operation.downcase}"
    end
  end

  MARKETPLACES = {
    au: Market.new('webservices.amazon.com.au', 'us-west-2'),
    br: Market.new('webservices.amazon.com.br', 'us-east-1'),
    ca: Market.new('webservices.amazon.ca',     'us-east-1'),
    fr: Market.new('webservices.amazon.fr',     'eu-west-1'),
    de: Market.new('webservices.amazon.de',     'eu-west-1'),
    in: Market.new('webservices.amazon.in',     'eu-west-1'),
    it: Market.new('webservices.amazon.it',     'eu-west-1'),
    jp: Market.new('webservices.amazon.co.jp',  'us-west-2'),
    mx: Market.new('webservices.amazon.com.mx', 'us-east-1'),
    es: Market.new('webservices.amazon.es',     'eu-west-1'),
    tr: Market.new('webservices.amazon.com.tr', 'eu-west-1'),
    ae: Market.new('webservices.amazon.ae',     'eu-west-1'),
    uk: Market.new('webservices.amazon.co.uk',  'eu-west-1'),
    us: Market.new('webservices.amazon.com',    'us-east-1')
  }.freeze
end
