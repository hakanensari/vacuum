require 'net/http'
require 'nokogiri'
require 'openssl'

%w{cart_operations lookup_operations search_operations builder cart
   error locale request response}.each do |f|
  require "amazon_product/#{f}"
end

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
