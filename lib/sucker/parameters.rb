module Sucker
  class Parameters < ::Hash
    CURRENT_API_VERSION = '2010-11-01'

    def initialize
      populate
    end

    def populate
      self.store 'Service',   'AWSECommerceService'
      self.store 'Version',   CURRENT_API_VERSION
      self.store 'Timestamp', timestamp
    end

    # Ensures all keys and values are strings and camelizes former.
    def normalize
      inject({}) do |hash, kv|
        k, v = kv
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
