require 'nokogiri'
require 'sucker/hash'

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

    # A shorthand that yields each match to a block
    #
    #   response.each('Item') { |item| process_item(item) }
    #
    def each(path)
      find(path).each { |match| yield match }
    end

    # Returns an array of errors in the reponse
    def errors
      find('Error')
    end

    # Queries an xpath and returns an array of matching nodes
    #
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

    # A shorthand that yields matches to a block and collects returned values
    #
    #   descriptions = response.map('Item') { |item| build_description(item) }
    #
    def map(path)
      find(path).map { |match| yield match }
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
