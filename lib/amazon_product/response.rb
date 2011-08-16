module AmazonProduct
  # A wrapper around the API response.
  class Response

    # The response body.
    attr_accessor :body

    # The HTTP status code of the response.
    attr_accessor :code

    def initialize(body, code)
      @body = body
      @code = code.to_i
    end

    # A shorthand that queries for a specified attribute and yields to a given
    # block each matching document.
    #
    #   response.each('Item') { |item| puts item }
    #
    def each(path, &block)
      find(path).each { |match| block.call(match) }
    end

    # An array of errors in the response.
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
        HashBuilder.from_xml(element)
      end
    end
    alias [] find

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
      HashBuilder.from_xml(xml)
    end

    # Checks if the HTTP response is OK.
    def valid?
      code == 200
    end

    # The XML document.
    def xml
      @xml ||= Nokogiri::XML(@body)
    end
  end
end
