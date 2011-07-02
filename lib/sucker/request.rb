require 'httpclient'
require 'openssl'
require 'sucker/parameters'

module Sucker
  # A wrapper around the API request.
  class Request
    extend Forwardable

    HOSTS = {
      :us  => 'ecs.amazonaws.com',
      :uk  => 'ecs.amazonaws.co.uk',
      :de  => 'ecs.amazonaws.de',
      :ca  => 'ecs.amazonaws.ca',
      :fr  => 'ecs.amazonaws.fr',
      :jp  => 'ecs.amazonaws.jp' }

    LOCALES = HOSTS.keys

    def_delegators :@config, :associate_tag, :associate_tag=,
                             :key, :key=,
                             :locale, :locale=,
                             :secret, :secret=

    # Creates a new a request.
    #
    # Takes an optional hash of attribute and value pairs.
    #
    #   request = Sucker.new(
    #     :locale        => :us,
    #     :key           => amazon_key,
    #     :secret        => amazon_secret)
    #     :associate_tag => amazon_tag)
    #
    def initialize(args = {})
      @config = Config
      args.each { |k, v| self.send("#{k}=", v) }
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

    def escape(value)
      value.gsub(/([^a-zA-Z0-9_.~-]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end
    end

    def host
      HOSTS[locale.to_sym]
    end

    def sign(query_string)
      digest = OpenSSL::Digest::Digest.new('sha256')
      url_string = ['GET', host, '/onca/xml', query_string].join("\n")
      hmac = OpenSSL::HMAC.digest(digest, secret, url_string)
      signature = escape([hmac].pack('m').chomp)

      query_string + '&Signature=' + signature
    end
  end
end
