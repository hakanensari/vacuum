# = Sucker
# Sucker is a thin Ruby wrapper to the {Amazon Product Advertising API}[http://docs.amazonwebservices.com/AWSECommerceService/latest/DG/].
#
module Sucker
  class Request
    HOSTS = {
      'US'  => 'ecs.amazonaws.com',
      'UK'  => 'ecs.amazonaws.co.uk',
      'DE'  => 'ecs.amazonaws.de',
      'CA'  => 'ecs.amazonaws.ca',
      'FR'  => 'ecs.amazonaws.fr',
      'JP'  => 'ecs.amazonaws.jp' }

    # The Amazon locale you wish to query
    attr_accessor :locale

    # Your Amazon secret access key
    attr_accessor :secret

    # The hash of parameters you wish to query Amazon with
    attr_accessor :parameters

    # The query, sans signature, passed on to Amazon
    attr_accessor :query

    def initialize(args)
      self.parameters = {
        "Service" => "AWSECommerceService",
        "Version" => Sucker::AMAZON_API_VERSION
      }

      args.each { |k, v| send("#{k}=", v) }
    end

    # A reusable, configurable cURL object
    def curl
      @curl ||= Curl::Easy.new

      yield @curl if block_given?

      @curl
    end

    # Hits Amazon with an API request
    def fetch
      curl.url = uri.to_s
      curl.perform
      puts curl.body_str
    end

    # A helper method that sets the AWS Access Key ID
    def key=(key)
      parameters["AWSAccessKeyId"] = key
    end

    # Returns the uri to be queried
    def uri
      return nil if !valid?

      URI::HTTP.build(
        :host   => host,
        :path   => path,
        :query  => signed_query)
    end

    # Returns true if request has key, secret, and a valid locale set
    def valid?
      !!locale && !!HOSTS[locale] && !!secret && !!parameters["AWSAccessKeyId"]
    end

    private

    def build_query
      self.query = parameters.
        sort.
        collect do |k, v|
          "#{URI.encode(k)}=" + URI.encode(v.is_a?(Array) ? v.join(",") : v)
        end.
        join("&")
    end

    def digest
      OpenSSL::Digest::Digest.new("sha256")
    end

    def host
      HOSTS[locale]
    end

    def path
      "/onca/xml"
    end

    def signed_query
      timestamp
      build_query

      string = ["GET", host, path, query].join("\n")
      hmac = OpenSSL::HMAC.digest(digest, secret, string)

      query + "&Signature=" + URI.encode([hmac].pack("m").chomp)
    end

    def timestamp
      self.parameters["Timestamp"] = Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
    end
  end
end
