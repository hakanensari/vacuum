module Vacuum
  module Endpoint
    # A Marketplace Web Services (MWS) API endpoint.
    class MWS < Base
      # A list of MWS API hosts.
      HOSTS = {
        'CA' => 'mws.amazonservices.ca',
        'CN' => 'mws.amazonservices.com.cn',
        'DE' => 'mws-eu.amazonservices.com',
        'ES' => 'mws-eu.amazonservices.com',
        'FR' => 'mws-eu.amazonservices.com',
        'IT' => 'mws-eu.amazonservices.com',
        'JP' => 'mws.amazonservices.jp',
        'UK' => 'mws-eu.amazonservices.com',
        'US' => 'mws.amazonservices.com'
      }

      # Internal: Gets/Sets the Symbol MWS API type.
      attr_accessor :api

      # Returns a String MWS API host.
      def host
        HOSTS[locale]
      end

      # Sets the String marketplace ID.
      #
      # Raises a Missing Marketplace error if marketplace ID is missing.
      def marketplace
        @marketplace or raise MissingMarketplace
      end

      # Sets the String marketplace ID tag.
      attr_writer :marketplace

      # Returns a String MWS API URL path.
      #
      # Raises a Not Implemented Error if API is not implemented.
      def path
        case api
        when :products
          '/Products/2011-10-01'
        else
          raise NotImplementedError
        end
      end

      # Sets the String seller ID.
      #
      # Raises a Missing Seller error if seller ID is missing.
      def seller
        @seller or raise MissingSeller
      end

      # Sets the String seller ID tag.
      attr_writer :seller
    end
  end
end
