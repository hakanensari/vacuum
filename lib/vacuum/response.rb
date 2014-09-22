require 'delegate'
require 'multi_xml'

module Vacuum
  class Response < SimpleDelegator
    class << self
      def parser
        @parser ||= MultiXml
      end

      attr_writer :parser
    end

    def parser
      @parser || self.class.parser
    end

    attr_writer :parser

    def parse
      parser.parse(body)
    end

    alias_method :to_h, :parse

    def body
      __getobj__.body.force_encoding('UTF-8')
    end
  end
end
