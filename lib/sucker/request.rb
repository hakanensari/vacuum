module Sucker

  # A wrapper around the API request
  class Request
    HOSTS = {
      :us  => 'ecs.amazonaws.com',
      :uk  => 'ecs.amazonaws.co.uk',
      :de  => 'ecs.amazonaws.de',
      :ca  => 'ecs.amazonaws.ca',
      :fr  => 'ecs.amazonaws.fr',
      :jp  => 'ecs.amazonaws.jp' }
    PATH = "/onca/xml"

    # The Amazon locale to query
    attr_accessor :locale

    # The Amazon secret access key
    attr_accessor :secret

    # The hash of parameters to query Amazon with
    attr_accessor :parameters

    def initialize(args)
      self.parameters = {
        "Service" => "AWSECommerceService",
        "Version" => Sucker::AMAZON_API_VERSION
      }

      args.each { |k, v| send("#{k}=", v) }
    end

    # A helper method that merges a hash into the parameters
    def <<(hash)
      self.parameters.merge!(hash)
    end

    # A reusable, configurable cURL object
    def curl
      @curl ||= Curl::Easy.new

      yield @curl if block_given?

      @curl
    end

    # Performs the request and returns a response object
    def get
      curl.url = uri.to_s
      curl.perform

      Response.new(curl)
    end

    # A helper method that sets the AWS Access Key ID
    def key=(key)
      parameters["AWSAccessKeyId"] = key
    end

    private

    # Timestamps parameters and concatenates them into a query string
    def build_query
      parameters.
        merge(timestamp).
        sort.
        collect do |k, v|
          "#{k}=" + CGI.escape(v.is_a?(Array) ? v.join(",") : v)
        end.
        join("&")
    end

    def host
      HOSTS[locale.to_sym]
    end

    # Returns a signed and timestamped query string
    def build_signed_query
      query = build_query

      digest = OpenSSL::Digest::Digest.new("sha256")
      string = ["GET", host, PATH, query].join("\n")
      hmac = OpenSSL::HMAC.digest(digest, secret, string)

      query + "&Signature=" + CGI.escape([hmac].pack("m").chomp)
    end

    def uri
      URI::HTTP.build(
        :host   => host,
        :path   => PATH,
        :query  => build_signed_query)
    end

    def timestamp
      { "Timestamp" => Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ') }
    end
  end
end
