module Vacuum
  module Request
    module Utils
      # Camelizes a value.
      #
      # val - A String value.
      #
      # Returns an upper-camelcased String.
      def self.camelize(val)
        val.split('_').map(&:capitalize).join
      end

      # Percent encodes a URI component.
      #
      # component - The String URI component to encode.
      #
      # Returns the String encoded component.
      def self.encode(component)
        Addressable::URI.encode_component \
          component, Addressable::URI::CharacterClasses::UNRESERVED
      end
    end
  end
end
