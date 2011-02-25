require 'nokogiri'
require 'sucker/parameters'
require 'sucker/response/hash'

module Sucker

  # A wrapper around the response
  class Response

    # The response body
    attr_accessor :body

    # The HTTP status code of the response
    attr_accessor :code

    def initialize(response)
      self.body = response.body
      self.code = response.code
    end

    # Returns an array of errors in the reponse
    def errors
      find('Error')
    end

    # Queries an xpath and returns an array of matching nodes
    #
    #   response = worker.get
    #   items = response.find('Item')
    #
    def find(path)
      xml.xpath("//xmlns:#{path}").map { |element| Hash.from_xml(element) }
    end

    alias_method :[], :find

    # Returns true if response contains errors
    def has_errors?
      errors.count > 0
    end

    # Parses response into a simple hash
    def to_hash
      Hash.from_xml(xml)
    end

    # Checks if the HTTP response is OK
    #
    #    response = worker.get
    #    p response.valid?
    #    => true
    #
    def valid?
      code == '200'
    end

    # The XML document
    #
    #    response = worker.get
    #    response.xml
    def xml
      @xml ||= Nokogiri::XML(body)
    end
  end
end
