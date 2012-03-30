module Vacuum
  module Endpoint
    # A Marketplace Web Services (MWS) Products API endpoint.
    class MWSProducts < MWS
      def path
        "/Products/2011-10-01"
      end
    end
  end
end
