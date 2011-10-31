require 'net/http'
require 'nokogiri'
require 'openssl'

%w{builder cart locale request response}.each do |f|
  require "vacuum/#{f}"
end

# Vacuum is a Ruby wrapper to the Amazon Product Advertising API.
module Vacuum
  class BadLocale     < ArgumentError; end
  class MissingKey    < ArgumentError; end
  class MissingSecret < ArgumentError; end
  class MissingTag    < ArgumentError; end

  class << self
    # Returns a locale for configuration
    #
    # @param [#to_sym] locale a locale key
    # @return [Vacuum::Locale] a locale
    #
    # @example
    #   Vacuum.configure :us do |c|
    #     c.key    = 'foo'
    #     c.secret = 'bar'
    #     c.tag    = 'baz'
    #   end
    #
    def configure(locale, &blk)
      locale = locale.to_sym

      (@locales ||= {})[locale] ||= Locale.new(locale).configure(&blk)
    end

    # Returns a request for specified locale
    #
    # @param [#to_sym] locale a locale key
    # @return [Vacuum::Request] a request
    #
    def new(locale)
      Request.new(@locales[locale.to_sym])
    end
  end
end
