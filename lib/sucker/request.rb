require 'httpclient'
require 'openssl'
require 'sucker/parameters'

module Sucker
  # A wrapper around the API request.
  class Request
    # The locale-specific configuration.
    attr_reader :config

    # Creates a new a request object.
    #
    # Takes a Config object.
    #
    # You should not be calling this method directly. Instead, use `Sucker.new`.
    def initialize(config)
      @config = config
    end

    # Merges a hash into the existing parameters.
    #
    #   request << {
    #     'Operation' => 'ItemLookup',
    #     'IdType'    => 'ASIN',
    #     'ItemId'    => '0816614024' }
    #
    def <<(hash)
      parameters.merge!(hash)
    end

    # The HTTP adapter.
    def adapter
      @adapter ||= HTTPClient.new
    end

    # Performs a request and returns a response.
    #
    #   response = request.get
    #
    def get
      response = adapter.get(url)
      Response.new(response)
    end

    # The query parameters.
    def parameters
      @parameters ||= Parameters.new
    end

    # Resets parameters and returns self.
    def reset
      parameters.reset
      self
    end

    # The request URL.
    def url
      URI::HTTP.build(
        :host   => config.host,
        :path   => '/onca/xml',
        :query  => sign(build_query_string)
      )
    end

    # Sets the Amazon API version timestamp.
    def version=(version)
      parameters['Version'] = version
    end

    private

    def build_query_string
      parameters.
        normalize.
        merge({ 'AWSAccessKeyId' => config.key,
                'AssociateTag'   => config.associate_tag.to_s }).
        sort.
        map { |k, v| "#{k}=" + escape(v) }.
        join('&')
    end

    def sign(query_string)
      digest = OpenSSL::Digest::Digest.new('sha256')
      url_string = ['GET', config.host, '/onca/xml', query_string].join("\n")
      hmac = OpenSSL::HMAC.digest(digest, config.secret, url_string)
      signature = escape([hmac].pack('m').chomp)

      query_string + '&Signature=' + signature
    end

    def escape(value)
      value.gsub(/([^a-zA-Z0-9_.~-]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end
    end
  end
end
