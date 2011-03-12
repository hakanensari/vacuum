require 'sucker/request'
require 'sucker/response'

# = Sucker
#
# Sucker is a Ruby wrapper to the Amazon Product Advertising API.
module Sucker

  # Initializes a request object.
  #
  #   worker = Sucker.new(
  #     :locale => :us,
  #     :key    => api_key,
  #     :secret => api_secret)
  #
  def self.new(args={})
    Request.new(args)
  end
end
