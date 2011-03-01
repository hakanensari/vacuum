require 'net/http'
require 'openssl'
require 'sucker/parameters'

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

    # Your Amazon associate tag
    attr_accessor :associate_tag

    # Your AWS access key
    attr_accessor :key

    # Local IP to route the request through
    attr_accessor :local_ip

    # Amazon locale
    attr_accessor :locale

    # Your AWS secret
    attr_accessor :secret

    # Initializes a request object
    #
    #   worker = Sucker.new(
    #     :key    => 'API KEY',
    #     :secret => 'API SECRET')
    #
    def initialize(args={})
      args.each { |k, v| send("#{k}=", v) }
    end

    # Merges a hash into the existing parameters
    #
    #   worker << {
    #     'Operation' => 'ItemLookup',
    #     'IdType'    => 'ASIN',
    #     'ItemId'    => '0816614024' }
    #
    def <<(hash)
      parameters.merge!(hash)
    end

    # Performs a request and returns a response
    #
    #   response = worker.get
    #
    def get
      response = bind_to local_ip do
        Net::HTTP.start(host) do |http|
          query = build_signed_query
          http.get("/onca/xml?#{query}")
        end
      end
      Response.new(response)
    end

    # The parameters to query Amazon with
    def parameters
      @parameters ||= Parameters.new
    end

    # Sets the Amazon API version
    #
    #   worker.version = '2010-06-01'
    #
    def version=(version)
      parameters['Version'] = version
    end

    private

    # I am gently monkey-patching TCPSocket here to be able to bind the request
    # to a local IP if specified, emulating cURL's interface option. Once a
    # request is made, I reverse the patch, leaving TCPSOcket in its original
    # state.
    def bind_to(local_ip)
      if local_ip
        TCPSocket.instance_eval do
          (class << self; self; end).instance_eval do
            alias_method :original_open, :open

            define_method(:open) do |conn_address, conn_port|
              original_open(conn_address, conn_port, local_ip)
            end
          end
        end
      end

      return_value = yield

      if local_ip
        TCPSocket.instance_eval do
          (class << self; self; end).instance_eval do
            alias_method :open, :original_open
            remove_method :original_open
          end
        end
      end

      return_value
    end

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
      HOSTS[locale]
    end
  end
end
