module Vacuum
  module Response
    # An Amazon Web Services (AWS) API response.
    class Base
      # Gets/Sets the String response body.
      attr_accessor :body

      # Gets/Sets the Integer HTTP response code.
      attr_accessor :code

      # Initializes a new Response.
      #
      # body - The String response body.
      # code - An HTTP response code that responds to to_i.
      def initialize(body, code)
        @body, @code = body, code.to_i
      end

      # Queries the response.
      #
      # query - String attribute to be queried.
      #
      # Yields matching nodes to a given block if one is given.
      #
      # Returns an Array of matching nodes or the return values of the yielded
      # block if latter was given.
      def find(query)
        xpath(query) do |node|
          hsh = Utils.xml_to_hash node
          block_given? ? yield(hsh) : hsh
        end
      end
      alias [] find

      # Similar to `find` but returns XML nodes instead of hashes, this way you
      # can keep query the resulting search with xpath.
      def xml_find(query)
        xpath(query) do |node|
          block_given? ? yield(node) : node
        end
      end

      # Returns a Hash representation of the response.
      def to_hash
        Utils.xml_to_hash xml
      end

      # Returns whether the HTTP response is OK.
      def valid?
        code == 200
      end

      # Returns an XML document.
      def xml
        @xml ||= Nokogiri::XML.parse @body
      end

      private
      def xpath(query, &block)
        path = if xml.namespaces.empty?
                 "//#{query}"
               else
                 "//xmlns:#{query}"
               end

        xml.xpath(path).map do |node|
          yield(node)
        end
      end
    end
  end
end
