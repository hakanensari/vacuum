module Sucker

  # A wrapper around the cURL response
  class Response
    attr_accessor :body, :code, :time

    def initialize(curl)
      self.body = curl.body_str
      self.code = curl.response_code
      self.time = curl.total_time
    end

    def to_h
      doc = Nokogiri::XML(body)
      content_to_string(doc.to_hash)
    end

    alias_method :to_hash, :to_h

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
