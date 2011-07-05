require 'sucker/config'
require 'sucker/request'
require 'sucker/response'

# = Sucker
#
# Sucker is a Ruby wrapper to the Amazon Product Advertising API.
module Sucker
  class << self
    # Initializes a request object.
    #
    #   request = Sucker.new(
    #     :locale => :us,
    #     :key    => api_key,
    #     :secret => api_secret)
    #
    def new(args={})
      Request.new(args)
    end

    # Configures locale-specific details.
    #
    #   Sucker.configure do |c|
    #     c.locale        = :us
    #     c.key           = api_key
    #     c.secret        = api_secret
    #     c.associate_tag = associate_tag
    #   end
    #
    def configure(&block)
      Config.configure(&block)
    end
  end
end
