# = Sucker
# Sucker is a minimalist Ruby wrapper to the {Amazon Product Advertising API}[http://docs.amazonwebservices.com/AWSECommerceService/latest/DG/].
#
module Sucker
  class Request
    SUFFIXES = {
      "US"  => "com",
      "UK"  => "co.uk",
      "DE"  => "de",
      "CA"  => "ca",
      "FR"  => "fr",
      "JP"  => "jp" }

    attr_accessor :locale, :secret, :parameters

    def initialize
      self.parameters = {
        "Service" => "AWSECommerceService",
        "Version" => Sucker::API_VERSION
      }

      yield self if block_given?
    end

    private

    def query
      parameters.
        sort.
        collect{ |k, v| "#{URI.encode(k)}=#{URI.encode(v)}" }.
        join("&")
    end

    def digest
      OpenSSL::Digest::Digest.new("sha256") rescue nil
    end

    def host
      return false unless locale && SUFFIXES[locale]

      "http://ecs.amazonaws.#{SUFFIXES[locale]}"
    end

    def sign
      return false unless host && !!secret

      signed_string = "GET\n#{host}\n/onca/xml\n#{query}"
      hmac = OpenSSL::HMAC.digest(digest, secret, signed_string)
      base64_hmac = [hmac].pack("m").chomp

      self.parameters["Signature"] = base64_hmac
    end

    def timestamp
      self.parameters["Timestamp"] = Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
    end
  end
end
