require 'forwardable'

module Sucker
  class Parameters
    extend Forwardable

    CURRENT_API_VERSION = '2010-11-01'

    def_delegators :@parameters, :[], :[]=, :has_key?, :merge!

    def initialize
      reset
    end

    # Creates a new hash to store parameters in.
    def reset
      @parameters = {
        'Service'   => 'AWSECommerceService',
        'Version'   => CURRENT_API_VERSION,
        'Timestamp' => timestamp }
    end

    # Returns a normalized parameters hash.
    #
    # Ensures all keys and values are strings and camelizes former.
    def normalize
      @parameters.inject({}) do |hash, (k, v)|
        v = v.is_a?(Array) ? v.join(',') : v.to_s
        k = k.to_s.split('_').map {|w| w[0, 1] = w[0, 1].upcase; w }.join
        hash[k] = v

        hash
      end
    end

    private

      def timestamp
        Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
      end
  end
end
