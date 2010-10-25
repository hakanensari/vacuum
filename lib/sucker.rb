require "active_support/xml_mini/nokogiri"
require "curb"
require "sucker/request"
require "sucker/response"
require "uri"

# = Sucker
#
# Sucker is a Ruby wrapper to the Amazon Product Advertising API.
module Sucker
  CURRENT_AMAZON_API_VERSION = "2010-09-01"

  # Initializes a request object
  #
  #   worker = Sucker.new(
  #     :locale => "us",
  #     :key    => "API KEY",
  #     :secret => "API SECRET")
  #
  def self.new(args={})
    Sucker::Request.new(args)
  end
end
