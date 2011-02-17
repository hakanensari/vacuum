# encoding: utf-8

require 'active_support/xml_mini/nokogiri'

module Sucker #:nodoc:

  # A Nokogiri-based wrapper around the response
  class Response

    # The response body
    attr_accessor :body

    # The HTTP status code of the response
    attr_accessor :code

    def initialize(response)
      self.body = response.body
      self.code = response.code
    end

    # Returns an array of errors in the reponse
    def errors
      find('Error')
    end

    # Queries an xpath and returns an array of matching nodes
    #
    #   response = worker.get
    #   items = response.find('Item')
    #
    def find(path)
      xml.xpath("//xmlns:#{path}").map { |e| strip_content(e.to_hash[path]) }
    end

    # Returns true if response contains errors
    def has_errors?
      errors.count > 0
    end

    # Parses response into a simple hash
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
      code == '200'
    end

    # The XML document
    #
    #    response = worker.get
    #    response.xml
    def xml
      @xml ||= Nokogiri::XML(body)
    end

    private

    # Massage hash
    def strip_content(node)
      case node
      when Array
        node.map { |child| strip_content(child) }
      when Hash
        if node.keys.size == 1 && node['__content__']
          node['__content__']
        else
          node.inject({}) do |attributes, kv|
            k, v = kv
            attributes.merge({ k => strip_content(v) })
          end
        end
      else
        node
      end
    end
  end
end
