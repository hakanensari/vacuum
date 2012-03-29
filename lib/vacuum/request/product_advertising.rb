module Vacuum
  module Request
    # A wrapper to a Product Advertising API request.
    class ProductAdvertising < Base
      # Returns the default Hash parameters shared by all Product Advertising
      # API requests.
      def default_parameters
        super.merge 'AssociateTag' => endpoint.tag,
                    'Service'      => 'AWSECommerceService',
                    'Version'      => '2011-08-01'
      end

      # Returns the Addressable::URI URL of the Product Advertising API
      # request.
      def url
        Addressable::URI.new :scheme        => 'http',
                             :host          => endpoint.host,
                             :path          => '/onca/xml',
                             :query_values  => parameters
      end
    end
  end
end
