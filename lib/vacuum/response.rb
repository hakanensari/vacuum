require 'delegate'
require 'multi_xml'

module Vacuum
  class Response < SimpleDelegator
    def to_h
      MultiXml.parse(body)
    end

    alias :to_hash :to_h
  end
end
