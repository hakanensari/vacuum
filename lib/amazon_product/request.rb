module AmazonProduct
  # A wrapper around the API request.
  class Request
    include Operations

    # The latest Amazon API version. See:
    # http://aws.amazon.com/archives/Product%20Advertising%20API
    CURRENT_API_VERSION = '2011-08-01'

    class << self
      # The HTTP client.
      attr :adapter

      # Sets the HTTP client.
      #
      # Takes the name of the client library as argument, which can be:
      #
      # * `:net_http`
      # * `:curb`
      # * `:synchrony`
      #
      # For the latter two, you will have to make available the
      # dependent gems manually.
      def adapter=(client)
        case client
        when :curb
          require 'curb'
        when :synchrony
          require 'em-synchrony'
          require 'em-synchrony/em-http'
        when :net_http
        else
          raise ArgumentError, ":#{client} is not a valid HTTP client"
        end

        @adapter = client
      end
    end

    # Set HTTP client to Net::HTTP.
    @adapter = :net_http

    # Creates a new request for specified locale.
    def initialize(locale)
      @locale = Locale.new(locale.to_sym)
      @params = Hash.new
    end

    # Merges a hash of request parameters into the query.
    #
    #   request << { :key => 'value }
    #
    def <<(hash)
      hash.each do |k, v|
        # Cast value to string.
        v = v.is_a?(Array) ? v.join(',') : v.to_s

        # Camelize key.
        k = k.to_s.split('_').map { |w| w[0, 1] = w[0, 1].upcase; w }.join

        @params[k] = v
      end
    end

    # Performs an asynchronous request with the EM async HTTP client.
    #
    # Yields response to given block.
    def aget(&block)
      unless adapter == :synchrony
        raise TypeError, "Set HTTP client to `:synchrony`"
      end

      http = EM::HttpRequest.new(url).aget
      resp = lambda { Response.new(http.response, http.response_header.status) }
      http.callback { block.call(resp.call) }
      http.errback  { block.call(resp.call) }
    end

    # Configures the Amazon locale.
    #
    #   request.configure do |c|
    #     c.key    = YOUR_KEY
    #     c.secret = YOUR_SECRET
    #     c.tag    = YOUR_ASSOCIATE_TAG
    #   end
    #
    def configure(&block)
      block.call @locale
    end

    # Performs a request.
    def get
      case adapter
      when :curb
        http = Curl::Easy.perform(url.to_s)
        body, code = http.body_str, http.response_code
      when :synchrony
        http = EM::HttpRequest.new(url).get
        body, code = http.response, http.response_header.status
      when :net_http
        resp = Net::HTTP.get_response(url)
        body, code = resp.body, resp.code
      end

      Response.new(body, code)
    end

    # The request parameters.
    def params
      raise MissingKey unless @locale.key
      raise MissingTag unless @locale.tag

      { 'AWSAccessKeyId' => @locale.key,
        'AssociateTag'   => @locale.tag,
        'Service'        => 'AWSECommerceService',
        'Timestamp'      => timestamp,
        'Version'        => CURRENT_API_VERSION }.merge(@params)
    end

    # A string representation of the request parameters.
    def query
      params.sort.map { |k, v| "#{k}=" + escape(v) }.join('&')
    end

    # Resets the request parameters.
    def reset
      @params = Hash.new
    end

    # Adds a signature to a query
    def sign(unsigned_query)
      raise MissingSecret unless @locale.secret

      digest = OpenSSL::Digest::Digest.new('sha256')
      url_string = ['GET', @locale.host, '/onca/xml', unsigned_query].join("\n")
      hmac = OpenSSL::HMAC.digest(digest, @locale.secret, url_string)
      signature = escape([hmac].pack('m').chomp)

      "#{unsigned_query}&Signature=#{signature}"
    end

    # The current timestamp.
    def timestamp
      Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
    end

    # The Amazon URL.
    def url
      URI::HTTP.build(:host  => @locale.host,
                      :path  => '/onca/xml',
                      :query => sign(query))
    end

    private

    def adapter
      Request.adapter
    end

    def escape(value)
      value.gsub(/([^a-zA-Z0-9_.~-]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end
    end
  end
end
