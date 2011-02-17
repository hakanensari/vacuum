# encoding: utf-8

require 'active_support/inflector'

module Sucker #:nodoc:

  class Parameters < Hash #:nodoc:
    API_VERSION = '2010-11-01'
    SERVICE     = 'AWSECommerceService'

    def initialize
      self.store 'Service',   SERVICE
      self.store 'Version',   API_VERSION
      self.store 'Timestamp', timestamp
    end

    def normalize
      inject({}) do |hash, kv|
        k, v = kv
        v = v.is_a?(Array) ? v.join(',') : v.to_s
        hash[k.to_s.camelize] = v
        hash
      end
    end

    private

    def timestamp
      Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
    end
  end
end
