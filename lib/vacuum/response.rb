module Vacuum
  # A wrapper around the API response.
  class Response

    # @return [String] body The response body
    attr_accessor :body

    # @return [Integer] code The HTTP status code of the response
    attr_accessor :code

    # Creates a new response.
    #
    # @param [String] body The response body
    # @param [#to_i] code The HTTP status code of the response
    def initialize(body, code)
      @body = body
      @code = code.to_i
    end

    # @return [Array] Errors in the response
    def errors
      find 'Error'
    end

    # Queries for a given attribute, yielding matching nodes to a block if
    # given one.
    #
    # @param [String] Query attribute to be queried
    # @yield Optionally passes matching nodes to a given block
    # @return [Array] Matches
    #
    # @example
    #   items = res.find('Item')
    #   asins = res.find('Item') { |item| item['ASIN'] }
    #
    def find(query)
      xml.xpath("//xmlns:#{query}").map do |node|
        hsh = HashBuilder.from_xml node
        block_given? ? yield(hsh) : hsh
      end
    end

    # @return [true, false] Whether the response has errors
    def has_errors?
      errors.count > 0
    end

    # @return [Hash] A hash representation of the entire response.
    def to_hash
      HashBuilder.from_xml xml
    end

    # @return [true, false] Whether the HTTP response is OK
    def valid?
      code == 200
    end

    # @return [Nokogiri::XML] the XML document
    def xml
      @xml ||= Nokogiri::XML @body
    end
  end
end
