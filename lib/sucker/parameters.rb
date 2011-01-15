require 'openssl'

module Sucker
  class Parameters < Hash #:nodoc: all
    include StringHelpers

    def initialize
      self.store 'Service', 'AWSECommerceService'
      self.store 'Version', CURRENT_AMAZON_API_VERSION
    end

    def build
      timestamp!

      sort.
      map do |k, v|
        "#{ camelize(k) }=" + escape(stringify(v))
      end.join('&')
    end

    def sign(host, path, secret)
      query = build
      digest = OpenSSL::Digest::Digest.new('sha256')
      string = ['GET', host, path, query].join("\n")
      hmac = OpenSSL::HMAC.digest(digest, secret, string)

      query + '&Signature=' + escape([hmac].pack('m').chomp)
    end

    def timestamp!
      store 'Timestamp', Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
    end
  end
end
