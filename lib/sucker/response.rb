module Sucker

  # A wrapper around the cURL response
  class Response
    attr_accessor :body, :code, :time, :xml

    def initialize(curl)
      self.body = curl.body_str
      self.code = curl.response_code
      self.time = curl.total_time
    end

    def to_h(path=nil)
      if path
        xml.xpath("//xmlns:#{path}").map { |node| content_to_string(node.to_hash[path]) }
      else
        content_to_string(xml.to_hash)
      end
    end

    alias :to_hash :to_h

    def xml
      @xml ||= Nokogiri::XML(body)
    end

    private

    def content_to_string(node)
      case node
      when Array 
        node.map { |el| content_to_string(el) }
      when Hash
        if node.keys.size == 1 && node["__content__"]
          node["__content__"]
        else
          node.inject({}) do |el, key_value|
            el.merge({ key_value.first => content_to_string(key_value.last) })
          end
        end
      else
        node
      end
    end
  end
end
