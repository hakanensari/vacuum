require 'forwardable'
require 'net/http'
require 'nokogiri'
require 'openssl'

require 'amazon_product/error'
require 'amazon_product/hash_builder'
require 'amazon_product/locale'
require 'amazon_product/request'
require 'amazon_product/response'

# Amazon Product is a Ruby wrapper to the Amazon Product Advertising API.
module AmazonProduct
  @requests = Hash.new

  # A request.
  #
  # Takes an Amazon locale as argument. This can be +ca+, +cn+, +de+, +fr+,
  # +it+, +jp+, +uk+, or +us+.
  #
  # The library will cache one request per locale.
  def self.[](locale)
    @requests[locale] ||= Request.new(locale)
  end
end
