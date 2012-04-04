# Standard library dependencies.
require 'base64'
require 'forwardable'
require 'openssl'
require 'time'

# External dependencies.
require 'addressable/uri'
require 'faraday'
require 'nokogiri'

# Internal dependencies.
require 'vacuum/endpoint/base'
require 'vacuum/request/base'
require 'vacuum/request/signature/authentication'
require 'vacuum/request/signature/builder'
require 'vacuum/request/utils'
require 'vacuum/response/base'
require 'vacuum/response/utils'
require 'vacuum/version'

# Vacuum is a Ruby wrapper to various Amazon Web Services (AWS) APIs.
module Vacuum
  BadLocale     = Class.new ArgumentError
  BadResponse   = Class.new StandardError
  MissingKey    = Class.new ArgumentError
  MissingSecret = Class.new ArgumentError

  class << self
    def new(api, &blk)
      case api
      when /^mws/
        require 'vacuum/mws'
        Request::MWS.new do |config|
          config.api = api.slice(4, api.size).to_sym
          blk.call config
        end
      when :product_advertising
        require 'vacuum/product_advertising'
        Request::ProductAdvertising.new &blk
      else
        raise NotImplementedError
      end
    end
  end
end
