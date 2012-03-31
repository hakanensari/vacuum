module Vacuum
  module Response
    # A Product Advertising API response.
    class ProductAdvertising < Base
      # Returns an Array of errors.
      def errors
        find 'Error'
      end

      # Returns whether the response has errors.
      #
      # Note that a response with errors is still technically valid, i.e. the
      # response code is 200.
      def has_errors?
        errors.count > 0
      end
    end
  end
end
