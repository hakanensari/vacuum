# frozen_string_literal: true

require 'delegate'
require 'forwardable'
require 'json'

module Vacuum
  # A wrapper around the API response
  class Response < SimpleDelegator
    extend Forwardable

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

    def to_h
      JSON.parse(body)
    end
  end
end
