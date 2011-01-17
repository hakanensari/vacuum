require 'active_support/inflector'

module Sucker
  class Parameters < Hash
    API_VERSION = '2010-11-01'
    SERVICE     = 'AWSECommerceService'

    def initialize #:nodoc
      self.store 'Service',   SERVICE
      self.store 'Version',   API_VERSION
      self.store 'Timestamp', timestamp
    end

    def normalize
      inject({}) do |h, kv|
        k, v = kv
        h[k.to_s.camelize] = v.is_a?(Array) ? v.join(',') : v.to_s
        h
      end
    end

    private

    def timestamp
      Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
    end
  end
end
