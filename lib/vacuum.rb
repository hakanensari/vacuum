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

# Vacuum is a Ruby wrapper to various Amazon Web Services (AWS) APIs.
module Vacuum
  class BadLocale     < ArgumentError; end
  class MissingKey    < ArgumentError; end
  class MissingSecret < ArgumentError; end

  class << self
    def new(api, &blk)
      require "vacuum/#{api}"

      case api
      when :product_advertising
        Request::ProductAdvertising.new &blk
      when :mws
        Request::MWS.new &blk
      end
    end
  end
end
