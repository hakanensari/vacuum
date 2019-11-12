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
    #   @see https://ruby-doc.org/core/Hash.html#method-i-dig
    def_delegator :to_h, :dig

    class << self
      attr_accessor :parser
    end

    def_delegator :to_h, :dig

    attr_writer :parser

    def parser
      @parser || self.class.parser
    end

    def parse
      parser ? parser.parse(body) : to_h
    end

    # Casts body to Hash
    # @return [Hash]
    def to_h
      JSON.parse(body)
    end
  end
end
