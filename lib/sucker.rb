require "active_support/xml_mini/nokogiri"
require "curb"
require "digest/md5"
require "sucker/request"
require "sucker/response"
require "uri"

# = Sucker
# Sucker is a Ruby wrapper to the Amazon Product Advertising API.
module Sucker
  CURRENT_AMAZON_API_VERSION = "2010-09-01"

  def self.new(args={})
    Sucker::Request.new(args)
  end
end
