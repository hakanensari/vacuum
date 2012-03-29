module Vacuum
  module Endpoint
    # A Product Advertising API endpoint.
    class ProductAdvertising < Base
      # A list of Product Advertising API hosts.
      HOSTS = {
        'CA' => 'ecs.amazonaws.ca',
        'CN' => 'webservices.amazon.cn',
        'DE' => 'ecs.amazonaws.de',
        'ES' => 'webservices.amazon.es',
        'FR' => 'ecs.amazonaws.fr',
        'IT' => 'webservices.amazon.it',
        'JP' => 'ecs.amazonaws.jp',
        'UK' => 'ecs.amazonaws.co.uk',
        'US' => 'ecs.amazonaws.com'
      }

      # Returns a String Product Advertising API host.
      def host
        HOSTS[locale]
      end

      # Sets the String Associate tag.
      #
      # Raises a Missing Tag error if tag is missing.
      def tag
        @tag or raise MissingTag
      end

      # Sets the String Associate tag.
      attr_writer :tag
    end
  end
end
