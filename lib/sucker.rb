require "active_support/xml_mini/nokogiri"
require "cgi"
require "curb"
require "digest/md5"
require "nokogiri"
require "sucker/request"
require "sucker/response"
require "sucker/version"
require "uri"

# = Sucker
# Sucker is a paper-thin Ruby wrapper to the Amazon Product Advertising API.
module Sucker
  AMAZON_API_VERSION = "2010-06-01"

  def self.new(args={})
    Sucker::Request.new(args)
  end
end
