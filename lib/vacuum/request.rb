module Vacuum
  # A wrapper around the request to the Amazon Product Advertising API.
  class Request
    # The latest Amazon API version.
    CURRENT_API_VERSION = '2011-08-01'

    # A list of Amazon endpoints.
    HOSTS = {
      :ca => 'ecs.amazonaws.ca',
      :cn => 'webservices.amazon.cn',
      :de => 'ecs.amazonaws.de',
      :es => 'webservices.amazon.es',
      :fr => 'ecs.amazonaws.fr',
      :it => 'webservices.amazon.it',
      :jp => 'ecs.amazonaws.jp',
      :uk => 'ecs.amazonaws.co.uk',
      :us => 'ecs.amazonaws.com'
    }

    # Creates a new request for given locale and credentials.
    #
    # @param [Hash] options
    # @option opts [#to_sym] :locale An Amazon locale
    # @option opts [String] :key An Amazon AWS access key ID
    # @option opts [String] :secret An Amazon AWS access secret key
    # @option opts [String] :tag An Amazon Associate tag
    # @raise [MissingKey] An Amazon AWS access key ID was not given
    # @raise [MissingSecret] An Amazon AWS secret key was not given
    # @raise [MissingTag] An Amazon Associate tag was not given
    # @return [self]
    def initialize(options)
      _reset!

      locale  = (options[:locale] || :us).to_sym
      @host   = HOSTS[locale]    or raise BadLocale
      @key    = options[:key]    or raise MissingKey
      @secret = options[:secret] or raise MissingSecret
      @tag    = options[:tag]    or raise MissingTag
    end

    # Merges given parameters into the request query.
    #
    # @param [Hash] hsh Pairs of keys and values
    # @return [self]
    def build(hsh)
      hsh.each do |k, v|
        @params[k] = v.is_a?(Array) ? v.join(',') : v.to_s
      end

      self
    end

    # Replaces the request query with given parameters.
    #
    # see(#build)
    def build!(hsh = {})
      _reset!
      build hsh
    end

    # Performs a request.
    #
    # @return [Vacuum::Response] A response
    def get
      res = Net::HTTP.get_response(url)
      Response.new(res.body, res.code)
    end

    # @return [Hash] The parameters that make up the request query.
    def params
      _default_params.merge(@params)
    end

    # @return [URI::HTTP] The URL for the API request
    def url
      URI::HTTP.build :host  => @host,
                      :path  => '/onca/xml',
                      :query => _query_string
    end

    private

    def _default_params
      default = {
        'AWSAccessKeyId' => @key,
        'AssociateTag'   => @tag,
        'Service'        => 'AWSECommerceService',
        'Timestamp'      => _timestamp,
        'Version'        => CURRENT_API_VERSION
      }
    end

    def _escape(value)
      value.gsub(/([^a-zA-Z0-9_.~-]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end
    end

    def _query_string
      qs   = params.sort.map { |k, v| "#{k}=" + _escape(v) }.join('&')
      dig  = OpenSSL::Digest::Digest.new 'sha256'
      req  = ['GET', @host, '/onca/xml', qs]
      hmac = OpenSSL::HMAC.digest dig, @secret, req.join("\n")
      sig  = _escape [hmac].pack('m').chomp

      "#{qs}&Signature=#{sig}"
    end

    def _reset!
      @params = {}
    end

    def _timestamp
      Time.now.utc.iso8601
    end
  end
end
