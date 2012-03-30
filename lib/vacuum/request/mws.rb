module Vacuum
  module Request
    # A wrapper to a Marketplace Web Services (MWS) API request.
    class MWS < Base
      # Returns the Addressable::URI URL of the MWS API
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
