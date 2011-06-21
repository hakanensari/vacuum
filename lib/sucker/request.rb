require 'httpclient'
require 'openssl'
require 'sucker/parameters'

module Sucker
  # A wrapper around the API request.
  class Request
    HOSTS = {
      :us  => 'ecs.amazonaws.com',
      :uk  => 'ecs.amazonaws.co.uk',
      :de  => 'ecs.amazonaws.de',
      :ca  => 'ecs.amazonaws.ca',
      :fr  => 'ecs.amazonaws.fr',
      :jp  => 'ecs.amazonaws.jp' }

    class << self

      # Available Amazon locales.
      def locales
        @locales ||= HOSTS.keys
      end
    end

    # The Amazon associate tag.
    attr_accessor :associate_tag

    # The Amazon Web Services access key.
    attr_accessor :key

    # The Amazon locale.
    attr_accessor :locale

    # The Amazon Web Services secret.
    attr_accessor :secret

    # Initializes a request object.
    #
    # Takes an optional hash of attribute and value pairs.
    #
    #   request = Sucker.new(
    #     :locale        => :us,
    #     :key           => amazon_key,
    #     :secret        => amazon_secret)
    #     :associate_tag => amazon_tag)
    #
    def initialize(args={})
      args.each { |k, v| send("#{k}=", v) }
    end

    # The HTTP adapter.
    def adapter
      @adapter ||= HTTPClient.new
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
        :host   => host,
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
          merge({ 'AWSAccessKeyId' => key,
                  'AssociateTag'   => associate_tag.to_s }).
          sort.
          map { |k, v| "#{k}=" + escape(v) }.
          join('&')
      end

      def sign(query_string)
        digest = OpenSSL::Digest::Digest.new('sha256')
        url_string = ['GET', host, '/onca/xml', query_string].join("\n")
        hmac = OpenSSL::HMAC.digest(digest, secret, url_string)
        signature = escape([hmac].pack('m').chomp)

        query_string + '&Signature=' + signature
      end

      def escape(value)
        value.gsub(/([^a-zA-Z0-9_.~-]+)/) do
          '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
        end
      end

      def host
        HOSTS[locale.to_sym]
      end
  end
end
