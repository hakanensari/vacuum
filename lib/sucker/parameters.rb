module Sucker
  class Parameters < ::Hash
    CURRENT_API_VERSION = '2010-11-01'

    def initialize
      store_basic_info
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

    def merge! hash
      clear
      store_basic_info
      super
    end

    private

    def store_basic_info
      self.store 'Service',   'AWSECommerceService'
      self.store 'Version',   CURRENT_API_VERSION
      self.store 'Timestamp', timestamp
    end

    def timestamp
      Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
    end
  end
end
