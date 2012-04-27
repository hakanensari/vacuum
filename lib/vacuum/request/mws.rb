module Vacuum
  module Request
    # A Marketplace Web Services (MWS) API request.
    class MWS < Base
      # Returns the Addressable::URI URL of the MWS API request.
      def url
        uri = Addressable::URI.new :scheme        => 'https',
                             :host          => endpoint.host,
                             :path          => endpoint.path
        uri.query_values = parameters
        uri
      end

      private

      def default_parameters
        super.merge 'MarketplaceId'    => endpoint.marketplace,
                    'SellerId'         => endpoint.seller,
                    'Service'          => 'AWSECommerceService',
                    'SignatureMethod'  => 'HmacSHA256',
                    'SignatureVersion' => '2'
      end
    end
  end
end
