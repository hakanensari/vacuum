module Vacuum
  module Request
    module Utils
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
