require "cgi"
require "crack/xml"
require "curb"
require "sucker/request"
require "sucker/response"

# = Sucker
# Sucker is a thin Ruby wrapper to the Amazon Product Advertising API.
module Sucker
  AMAZON_API_VERSION  = "2009-11-01"

  def self.new(args={})
    Sucker::Request.new(args)
  end
end
