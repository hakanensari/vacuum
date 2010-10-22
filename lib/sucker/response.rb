module Sucker #:nodoc

  # A Nokogiri-driven wrapper around the cURL response
  class Response

    # The response body
    attr_accessor :body

    # The HTTP status code of the response
    attr_accessor :code

    # Transaction time in seconds for request
    attr_accessor :time

    def initialize(curl)
      self.body = curl.body_str
      self.code = curl.response_code
      self.time = curl.total_time
    end

    # Queries an xpath and returns result as an array of hashes
    #
    # For instance, to get all items in an item lookup query:
    #
    #   response = worker.get
    #   response.node("Item").each { |item| ... }
    #
    def node(path)
      xml.xpath("//xmlns:#{path}").map { |node| strip_content(node.to_hash[path]) }
    end

    # Parses the response into a simple hash
    #
    #   response = worker.get
    #   response.to_hash
    #
    def to_hash
      strip_content(xml.to_hash)
    end

    # Checks if the HTTP response is OK
    #
    #    response = worker.get
    #    p response.valid?
    #    => true
    #
    def valid?
      code == 200
    end

    # The XML document
    #
    #    response = worker.get
    #    response.xml
    def xml
      @xml ||= Nokogiri::XML(body)
    end

    private

    # Let's massage the somewhat-verbose XML Mini hash into better shape
    def strip_content(node)
      case node
      when Array 
        node.map { |child| strip_content(child) }
      when Hash
        if node.keys.size == 1 && node["__content__"]
          node["__content__"]
        else
          node.inject({}) do |attributes, key_value|
            attributes.merge({ key_value.first => strip_content(key_value.last) })
          end
        end
      else
        node
      end
    end
  end
end
