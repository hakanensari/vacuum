# frozen_string_literal: true

require 'delegate'
require 'forwardable'
require 'json'

module Vacuum
  # A wrapper around the API response
  class Response < SimpleDelegator
    extend Forwardable

    # @!method dig(*key)
    #   Delegates to {Response#to_h} to extract a nested value specified by the
    #     sequence of keys
    #   @param [String] key
    #   @see Hash#dig
    def_delegator :to_h, :dig

    # Casts body to Hash
    # @return [Hash]
    def to_h
      JSON.parse(body)
    end
  end
end
