require "cgi"
require "curb"
require "digest/md5"
require "nokogiri"
require "sucker/request"
require "sucker/response"
require "uri"

if Gem.available?("activesupport", ">= 2.3.2")
  require "active_support/xml_mini/nokogiri"
else
  require "sucker/active_support/core_ext/object/blank"
  require "sucker/active_support/xml_mini/nokogiri"
end

# = Sucker
# Sucker is a paper-thin Ruby wrapper to the Amazon Product Advertising API.
module Sucker
  AMAZON_API_VERSION = "2010-06-01".freeze

  # Instantiates a new Sucker::Request
  def self.new(args={})
    Sucker::Request.new(args)
  end
end
