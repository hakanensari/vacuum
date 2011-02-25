# encoding: utf-8

require 'sucker/request'
require 'sucker/response'

# = Sucker
#
# Sucker is a Ruby wrapper to the Amazon Product Advertising API.
module Sucker

  # Initializes a request object
  #
  #   worker = Sucker.new(
  #     :locale => :us,
  #     :key    => 'API KEY',
  #     :secret => 'API SECRET')
  #
  def self.new(args={})
    Request.new(args)
  end
end
