module Sucker #:nodoc

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

    # Initializes a request object
    #
    #   worker = Sucker.new(
    #     :locale => "us",
    #     :key    => "API KEY",
    #     :secret => "API SECRET")
    #
    def initialize(args)
      self.parameters = {
        "Service" => "AWSECommerceService",
        "Version" => CURRENT_AMAZON_API_VERSION
      }

      args.each { |k, v| send("#{k}=", v) }
    end

    # Merges a hash into existing parameters
    #
    #   worker = Sucker.new
    #   worker << {
    #     "Operation"     => "ItemLookup",
    #     "IdType"        => "ASIN",
    #     "ItemId"        => "0816614024",
    #     "ResponseGroup" => "ItemAttributes" }
    #
    def <<(hash)
      self.parameters.merge!(hash)
    end

    # Sets the associate tag
    #
    #   worker = Sucker.new
    #   worker.associate_tag = 'foo-bar'
    #
    def associate_tag=(token)
      parameters["AssociateTag"] = token
    end

    # A configurable curl object
    #
    #   worker = Sucker.new
    #   worker.curl { |c| c.interface = "eth1" }
    #
    def curl
      @curl ||= Curl::Easy.new
      yield @curl if block_given?
      @curl
    end

    # Performs the request and returns a response object
    #
    #   worker = Sucker.new
    #   response = worker.get
    #
    def get
      curl.url = uri.to_s
      curl.perform

      Response.new(curl)
    end

    # Similar to get but raises an error if response is not valid
    def get!
      response = get

      unless response.valid?
        raise ResponseError, response.inspect
      end

      response
    end

    # Sets the AWS Access Key ID
    #
    #   worker = Sucker.new
    #   worker.key = 'foo'
    #
    def key=(token)
      parameters["AWSAccessKeyId"] = token
    end

    # Sets the Amazon API version
    #
    #   worker = Sucker.new
    #   worker.version = '2010-06-01'
    #
    def version=(version)
      self.parameters["Version"] = version
    end

    private

    # Timestamps parameters and concatenates them into a query string
    def build_query
      parameters.
        merge(timestamp).
        sort.
        collect do |k, v|
          "#{k}=" + escape(v.is_a?(Array) ? v.join(",") : v.to_s)
        end.
        join("&")
    end

    # Returns a signed and timestamped query string
    def build_signed_query
      query = build_query

      digest = OpenSSL::Digest::Digest.new("sha256")
      string = ["GET", host, PATH, query].join("\n")
      hmac = OpenSSL::HMAC.digest(digest, secret, string)

      query + "&Signature=" + escape([hmac].pack("m").chomp)
    end

    # Plagiarized from the Ruby CGI library via ruby_aaws
    def escape(string)
      string.gsub( /([^a-zA-Z0-9_.~-]+)/ ) do
        '%' + $1.unpack( 'H2' * $1.bytesize ).join( '%' ).upcase
      end
    end

    def host
      HOSTS[locale.to_sym]
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
