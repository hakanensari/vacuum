module AmazonProduct
  # A wrapper around the API request.
  class Request
    extend Forwardable

    # The latest Amazon API version. See:
    # http://aws.amazon.com/archives/Product%20Advertising%20API
    CURRENT_API_VERSION = '2011-08-01'

    # The Amazon locale.
    attr :locale

    def_delegators :locale, :host, :key, :secret, :tag

    # Creates a new request for specified locale.
    def initialize(locale)
      @locale = Locale.new(locale.to_sym)
      @params = Hash.new
    end

    # Merges a hash of request parameters into the query.
    def <<(hash)
      hash.each do |k, v|
        # Cast value to string.
        v = v.is_a?(Array) ? v.join(',') : v.to_s

        # Camelize key.
        k = k.to_s.split('_').map { |w| w[0, 1] = w[0, 1].upcase; w }.join

        @params[k] = v
      end
    end

    # Configures the Amazon locale.
    def configure
      yield locale
    end

    # The request parameters.
    def params
      raise MissingKey unless key
      raise MissingTag unless tag

      { 'AWSAccessKeyId' => key,
        'AssociateTag'   => tag,
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

    # Performs a request.
    def get
      resp = Net::HTTP.get_response(url)
      Response.new(resp)
    end

    # Adds a signature to a query
    def sign(unsigned_query)
      raise MissingSecret unless secret

      digest = OpenSSL::Digest::Digest.new('sha256')
      url_string = ['GET', host, '/onca/xml', unsigned_query].join("\n")
      hmac = OpenSSL::HMAC.digest(digest, secret, url_string)
      signature = escape([hmac].pack('m').chomp)

      "#{unsigned_query}&Signature=#{signature}"
    end

    # The current timestamp.
    def timestamp
      Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
    end

    # The Amazon URL.
    def url
      URI::HTTP.build(:host  => host,
                      :path  => '/onca/xml',
                      :query => sign(query))
    end

    private

    def escape(value)
      value.gsub(/([^a-zA-Z0-9_.~-]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end
    end
  end
end
