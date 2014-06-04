require 'delegate'
require 'multi_xml'

module Vacuum
  class Response < SimpleDelegator
    def to_h
      MultiXml.parse(body)
    end

    def body
      __getobj__.body.force_encoding('UTF-8')
    end
  end
end
