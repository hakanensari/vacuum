require 'nokogiri'
require 'sucker/hash'

module Sucker

  # A wrapper around the API response.
  class Response

    # The response body.
    attr_accessor :body

    # The HTTP status code of the response.
    attr_accessor :code

    def initialize(response)
      self.body = response.body
      self.code = response.code
    end

    # A shorthand that queries for a specified attribute and yields to a given
    # block each matching document.
    #
    #   response.each('Item') { |item| process_item(item) }
    #
    def each(path, &block)
      find(path).each { |match| block.call(match) }
    end

    # Returns an array of errors in the response.
    def errors
      find('Error')
    end

    # Queries for a specified attribute and returns an array of matching
    # documents.
    #
    #   items = response.find('Item')
    #
    def find(attribute)
      xml.xpath("//xmlns:#{attribute}").map do |element|
        Hash.from_xml(element)
      end
    end
    alias_method :[], :find

    # Returns true if the response contains errors.
    def has_errors?
      errors.count > 0
    end

    # A shorthand that queries for a specifed attribute, yields to a given
    # block matching documents, and collects final values.
    #
    #   items = response.map('Item') { |item| # do something }
    #
    def map(path, &block)
      find(path).map { |match| block.call(match) }
    end

    # Parses the response into a simple hash.
    def to_hash
      Hash.from_xml(xml)
    end

    # Checks if the HTTP response is OK.
    #
    #    response = worker.get
    #    response.valid?
    #    => true
    #
    def valid?
      code == 200
    end

    # The XML document.
    #
    #    response = worker.get
    #    response.xml
    #
    def xml
      @xml ||= Nokogiri::XML(body)
    end
  end
end
