module Sucker

  # A wrapper around the cURL response
  class Response
    attr_accessor :body, :code, :time, :xml

    def initialize(curl)
      self.body = curl.body_str
      self.code = curl.response_code
      self.time = curl.total_time
    end

    # Returns a collection of hashified nodes
    def node(path)
      xml.xpath("//xmlns:#{path}").map { |node| strip_content(node.to_hash[path]) }
    end

    # Hashifies the entire XML document
    def to_hash
      strip_content(xml.to_hash)
    end

    alias :to_h :to_hash

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
