# frozen_string_literal: true

require 'delegate'
require 'forwardable'
require 'json'

module Vacuum
  # A wrapper around the API response
  class Response < SimpleDelegator
    extend Forwardable

    # @!method dig(*key)
    #   Delegates to the Hash returned by {Response#to_h} to extract a nested
    #   value specified by the sequence of keys
    #
    #   @param [String] key one or more keys
    #   @see https://ruby-doc.org/core/Hash.html#method-i-dig
    def_delegator :to_h, :dig

    class << self
      # @return [nil,.parse] an optional custom parser
      attr_accessor :parser
    end

    # @return [nil,.parse] an optional custom parser
    attr_writer :parser

    # @!attribute [r] parser
    # @return [nil,.parse] an optional custom parser
    def parser
      @parser || self.class.parser
    end

    # Parses the response body
    #
    # @note Delegates to {#to_h} if no custom parser is set
    def parse
      parser&.parse(body) || to_h
    end

    # Casts body to Hash
    #
    # @return [Hash]
    def to_h
      JSON.parse(body)
    end
  end
end
