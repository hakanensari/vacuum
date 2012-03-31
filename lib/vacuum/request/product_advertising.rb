module Vacuum
  module Request
    # A Product Advertising API request.
    class ProductAdvertising < Base
      # Returns the Addressable::URI URL of the Product Advertising API
      # request.
      def url
        Addressable::URI.new :scheme        => 'http',
                             :host          => endpoint.host,
                             :path          => '/onca/xml',
                             :query_values  => parameters
      end

      private

      def default_parameters
        super.merge 'AssociateTag' => endpoint.tag,
                    'Service'      => 'AWSECommerceService',
                    'Version'      => '2011-08-01'
      end
    end
  end
end
