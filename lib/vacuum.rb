# frozen_string_literal: true

require "forwardable"

require "vacuum/client"
require "vacuum/version"

# Ruby wrapper to the Amazon Creators API
module Vacuum
  class << self
    extend Forwardable

    # @!method new
    #   Delegates to {Client} to create a new client
    #
    #   @return [Client]
    #   @see Client#initialize
    def_delegator "Vacuum::Client", :new
  end
end
