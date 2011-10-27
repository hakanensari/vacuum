require 'net/http'
require 'nokogiri'
require 'openssl'

%w{cart_operations lookup_operations search_operations builder cart
   error locale request response}.each do |f|
  require "vacuum/#{f}"
end

# Vacuum is a Ruby wrapper to the Amazon Product Advertising
# API.
module Vacuum
  @requests = Hash.new

  # @param [#to_sym] locale a locale key
  # @return [Vacuum::Request] a request
  #
  # @note The locale key may be any of the following: +ca+, +cn+, +de+,
  # +es+, +fr+, +it+, +jp+, +uk+, or +us+.
  def self.[](locale)
    @requests[locale] ||= Request.new(locale)
  end
end
