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
  end
end
