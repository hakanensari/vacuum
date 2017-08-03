require 'delegate'
require 'dig_rb'
require 'forwardable'
require 'multi_xml'

module Vacuum
  # A wrapper around the Amazon Product Advertising API response.
  class Response < SimpleDelegator
    extend Forwardable

    class << self
      attr_accessor :parser
    end

    def_delegator :parse, :dig

    attr_writer :parser

    def parser
      @parser || self.class.parser
    end

    def parse
      parser ? parser.parse(body) : to_h
    end

    def to_h
      MultiXml.parse(body)
    end

    def body
      __getobj__.body.force_encoding('UTF-8')
    end
  end
end
