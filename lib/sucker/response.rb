module Sucker

  # A Nokogiri-driven wrapper around the cURL response
  class Response
    attr_accessor :body, :code, :time, :xml

    def initialize(curl)
      self.body = curl.body_str
      self.code = curl.response_code
      self.time = curl.total_time
    end

    # Queries an xpath and returns a collection of hashified matches 
    def node(path)
      xml.xpath("//xmlns:#{path}").map { |node| strip_content(node.to_hash[path]) }
    end

    # Hashifies XML document or node
    def to_hash
      strip_content(xml.to_hash)
    end

    alias :to_h :to_hash

    # The XML document
    def xml
      @xml ||= Nokogiri::XML(body)
    end

    private

    def strip_content(node)
      case node
      when Array 
        node.map { |el| strip_content(el) }
      when Hash
        if node.keys.size == 1 && node["__content__"]
          node["__content__"]
        else
          node.inject({}) do |coll, key_value|
            coll.merge({ key_value.first => strip_content(key_value.last) })
          end
        end
      else
        node
      end
    end
  end
end
