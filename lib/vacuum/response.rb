require 'delegate'
require 'multi_xml'

module Vacuum
  class Response < SimpleDelegator
    def to_h
      MultiXml.parse(body)
    end
  end
end
