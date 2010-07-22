require "cgi"
require "crack/xml"
require "curb"
require "sucker/request"

module Sucker
  VERSION             = "0.1.0".freeze
  AMAZON_API_VERSION  = "2009-11-01".freeze

  class SuckerError < StandardError; end

  def self.new(args={})
    Sucker::Request.new(args)
  end
end
