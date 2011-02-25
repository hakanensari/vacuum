module Sucker
  class Request
    class Parameters < Hash
      API_VERSION = '2010-11-01'
      SERVICE     = 'AWSECommerceService'

      def initialize
        self.store 'Service',   SERVICE
        self.store 'Version',   API_VERSION
        self.store 'Timestamp', timestamp
      end

      # Ensures all keys and values are strings and camelizes former.
      def normalize
        inject({}) do |hash, kv|
          k, v = kv
          v = v.is_a?(Array) ? v.join(',') : v.to_s
          hash[k.to_s.split('_').map {|w| w[0, 1] = w[0, 1].upcase; w }.join] = v
          hash
        end
      end

      private

      def timestamp
        Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
      end
    end
  end
end
