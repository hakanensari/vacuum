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

  # Returns a request for specified locale
  #
  # @param [#to_sym] locale a locale key
  # @return [Vacuum::Request] a request
  #
  # @note The locale key may be any of the following:
  # +ca+, +cn+, +de+, +es+, +fr+, +it+, +jp+, +uk+, +us+
  def self.[](locale)
    @requests ||= Hash.new
    @requests[locale] ||= Request.new(locale)
  end
end
