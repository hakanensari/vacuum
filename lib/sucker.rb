require "cgi"
require "crack/xml"
require "curb"
require "sucker/request"

module Sucker
  AMAZON_API_VERSION  = "2009-11-01"

  def self.new(args={})
    Sucker::Request.new(args)
  end
end
