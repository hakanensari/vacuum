require 'httpi'
require 'openssl'
require 'sucker/parameters'

HTTPI.log = false

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

    # Available Amazon locales.
    def self.locales
      @locales ||= HOSTS.keys
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
    #   worker = Sucker.new(
    #     :locale        => :us,
    #     :key           => a_key,
    #     :secret        => a_secret,
    #     :associate_tag => a_tag)
    #
    def initialize(args={})
      args.each { |k, v| send("#{k}=", v) }
    end

    # Merges a hash into the existing parameters.
    #
    #   worker << {
    #     'Operation' => 'ItemLookup',
    #     'IdType'    => 'ASIN',
    #     'ItemId'    => '0816614024' }
    #
    def <<(hash)
      parameters.merge!(hash)
    end

    # Performs a request and returns a response object.
    #
    #   response = worker.get
    #
    def get(adapter = nil, &block)
      response = HTTPI.get(uri.to_s, block)
      response = HTTPI.get(uri.to_s, adapter, &block)
      Response.new(response)
    end

    # The query parameters.
    def parameters
      @parameters ||= Parameters.new
    end

    # Sets the Amazon API version.
    #
    #   worker.version = '2010-06-01'
    #
    def version=(version)
      parameters['Version'] = version
    end

    private

    def build_query
      parameters.
        normalize.
        merge({ 'AWSAccessKeyId' => key,
                'AssociateTag'   => associate_tag.to_s }).
        sort.
        map { |k, v| "#{k}=" + escape(v) }.
        join('&')
    end

    def build_signed_query
      query = build_query

      digest = OpenSSL::Digest::Digest.new('sha256')
      string = ['GET', host, '/onca/xml', query].join("\n")
      hmac = OpenSSL::HMAC.digest(digest, secret, string)
      signature = escape([hmac].pack('m').chomp)

      query + '&Signature=' + signature
    end

    def escape(value)
      value.gsub(/([^a-zA-Z0-9_.~-]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end
    end

    def host
      HOSTS[locale.to_sym]
    end

    def uri
      URI::HTTP.build(
        :host   => host,
        :path   => '/onca/xml',
        :query  => build_signed_query)
    end
  end
end
