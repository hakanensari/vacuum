module Vacuum
  # A wrapper around the API response
  class Response

    # @return [String] body the response body
    attr_accessor :body

    # @return [Integer] code the HTTP status code of the response
    attr_accessor :code

    # Creates a new response
    #
    # @param [String] body the response body
    # @param [#to_i] code the HTTP status code of the response
    def initialize(body, code)
      @body = body
      @code = code.to_i
    end

    # Queries for a specified attribute and yields to a given block
    # each matching document
    #
    # @param [String] query attribute to be queried
    # @yield passes matching nodes to given block
    #
    # @example
    #   res.each('Item') { |item| p item }
    #
    def each(query, &block)
      find(query).each { |match| block.call(match) }
    end

    # @return [Array] errors in the response
    def errors
      find('Error')
    end

    # Queries for a specified attribute and returns matching nodes
    #
    # @param [String] query attribute to be queried
    # @return [Array] matching nodes
    #
    # @example
    #   items = res.find('Item')
    #
    def find(query)
      xml.xpath("//xmlns:#{query}").map { |e| Builder.from_xml(e) }
    end
    alias [] find

    # @return [true, false] checks if the response has errors
    def has_errors?
      errors.count > 0
    end

    # Queries for a specifed attribute, yields to a given block
    # matching nodes, and collects final values.
    #
    # @param [String] query attribute to be queried
    # @yield passes matching nodes to given block
    # @return [Array] processed results
    #
    # @example
    #   asins = res.map('Item') { |item| item['ASIN'] }
    #
    def map(path, &block)
      find(path).map { |match| block.call(match) }
    end

    # @return [Hash] a hashified version of the response body
    def to_hash
      Builder.from_xml(xml)
    end

    # @return [true, false] checks if the HTTP response is OK
    def valid?
      code == 200
    end

    # @return [Nokogiri::XML] the XML document
    def xml
      @xml ||= Nokogiri::XML(@body)
    end
  end
end
