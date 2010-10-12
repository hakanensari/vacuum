# encoding: utf-8
module Sucker

  # A Nokogiri-driven wrapper around the cURL response
  class Response
    attr_accessor :body, :code, :time

    def initialize(curl)
      self.body = curl.body_str
      self.code = curl.response_code
      self.time = curl.total_time
    end

    # Queries an xpath and returns result as an array of hashes
    def node(path)
      xml.xpath("//xmlns:#{path}").map { |node| strip_content(node.to_hash[path]) }
    end

    # Parses the response into a simple hash
    def to_hash
      strip_content(xml.to_hash)
    end

    # Checks if the HTTP response is OK
    def valid?
      code == 200
    end

    # The XML document
    def xml
      @xml ||= Nokogiri::XML(body)
    end

    private

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
