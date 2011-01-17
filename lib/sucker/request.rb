require 'curb'
require 'openssl'
require 'uri'

module Sucker #:nodoc:

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

    # The Amazon secret access key
    attr_accessor :secret

    # Initializes a request object
    #
    #   worker = Sucker.new(
    #     :key    => "API KEY",
    #     :secret => "API SECRET")
    #
    def initialize(args)
      args.each { |k, v| send("#{k}=", v) }
    end

    # Merges a hash into the existing parameters
    #
    #   worker << {
    #     "Operation" => "ItemLookup",
    #     "IdType"    => "ASIN",
    #     "ItemId"    => "0816614024" }
    #
    def <<(hash)
      self.parameters.merge!(hash)
    end

    # Returns the associate tag for the current locale
    def associate_tag
      @associate_tags[locale.to_sym] rescue ''
    end

    # Sets the associate tag for the current locale
    #
    #   worker.associate_tag = 'foo-bar'
    #
    def associate_tag=(token)
      associate_tags[locale.to_sym] = token
    end

    # Gets the associate tags for all locales
    def associate_tags
      @associate_tags ||= {}
    end

    # Sets associate tags for all locales
    #
    # You need a distinct associate tag for each locale.
    #
    #    tags = {
    #      :us => 'foo-bar-10',
    #      :uk => 'foo-bar-20',
    #      ... }
    #
    #    worker.associate_tags = tags
    #
    def associate_tags=(tokens)
      @associate_tags = tokens
    end

    # Returns options for curl and yields them if given a block
    #
    #   worker.curl_opts { |c| c.interface = "eth1" }
    #
    def curl_opts
      @curl_opts ||= OpenStruct.new
      yield @curl_opts if block_given?

      @curl_opts.marshal_dump
    end

    # Performs a request and returns a response
    #
    #   response = worker.get
    #
    # Optionally, pass one or more locales to query specific locales or `:all`
    # to query all locales.
    #
    #   responses = worker.get(:us)
    #
    #   responses = worker.get(:all)
    #
    def get(*args)
      case args.count

      when 0
        curl = Curl::Easy.perform(uri.to_s) do |easy|
          curl_opts.each { |k, v| easy.send("#{k}=", v) }
        end
        Response.new(curl)

      when 1
        arg = args.first
        if arg == :all
          get_multi locales
        else
          self.locale = arg
          get
        end

      else
        get_multi args
      end
    end

    def get_all # :nodoc:
      warn "[DEPRECATION] `get_all` is deprecated. Please use `get(:all) instead."
      get(:all)
    end

    # Returns the AWS access key for the current locale
    def key
      raise ArgumentError.new "AWS access key missing" unless @keys[locale]

      @keys[locale]
    end

    # Sets a global AWS access key
    #
    #   worker.key = 'foo'
    #
    def key=(token)
      @keys = locales.inject({}) do |keys, locale|
        keys[locale] = token
        keys
      end
    end

    # Sets distinct AWS access keys for the locales
    #
    # You can use the same key on multiple venues. Caveat: Calls against (1) the US
    # and Canada and (2) the UK, France, and Germany count against the same call
    # rate quota.
    #
    #   keys = {
    #     :us => 'foo',
    #     :uk => 'bar',
    #     ... }
    #
    #   worker.keys = keys
    #
    def keys=(tokens)
      @keys = tokens
    end

    def locale
      raise ArgumentError.new "Locale not set" unless @locale

      @locale
    end

    # Sets the current Amazon locale
    #
    # Valid values are :us, :uk, :de, :ca, :fr, and :jp.
    def locale=(new_locale)
      new_locale = new_locale.to_sym

      raise ArgumentError.new "Invalid locale" unless locales.include? new_locale

      @locale = new_locale
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
      self.parameters['Version'] = version
    end

    private

    def build_query
      parameters.
        normalize.
        merge({ 'AWSAccessKeyId' => key }).
        merge({ 'AssociateTag'   => associate_tag }).
        sort.
        map do |k, v|
          "#{k}=" + escape(v)
        end.join('&')
    end

    def build_signed_query
      query = build_query

      digest = OpenSSL::Digest::Digest.new('sha256')
      string = ['GET', host, PATH, query].join("\n")
      hmac = OpenSSL::HMAC.digest(digest, secret, string)
      signature = escape([hmac].pack('m').chomp)

      query + '&Signature=' + signature
    end

    def escape(value)
      value.gsub(/([^a-zA-Z0-9_.~-]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end
    end

    def get_multi(locales)
      responses = []

      Curl::Multi.get(uris, curl_opts) do |curl|
        response = Response.new(curl)
        yield response if block_given?
        responses << response
      end

      responses
    end

    def host
      HOSTS[locale]
    end

    def locales
      @locales ||= HOSTS.keys
    end

    def uri
      URI::HTTP.build(
        :host   => host,
        :path   => PATH,
        :query  => build_signed_query)
    end

    def uris
      locales.map do |locale|
        self.locale = locale
        uri.to_s
      end
    end
  end
end
