require 'vacuum/cart_operations'
require 'vacuum/lookup_operations'
require 'vacuum/search_operations'

module Vacuum
  # A wrapper around the request to the Amazon Product Advertising API
  class Request
    include CartOperations
    include LookupOperations
    include SearchOperations

    # The latest Amazon API version
    #
    # @see http://aws.amazon.com/archives/Product%20Advertising%20API
    #
    # @note If you have a whitelisted access key, override this in your
    # parameters with the earlier `2010-11-01`.
    CURRENT_API_VERSION = '2011-08-01'

    # Creates a new request for specified locale
    #
    # @param [#Vacuum::Locale] a locale
    def initialize(locale)
      @locale, @params = locale, Hash.new
    end

    # Merges a hash of request parameters into the query
    #
    # @param [Hash] hsh pairs of parameter keys and values
    # @return [Vacuum::Request] the request object
    #
    # @example
    #   request << { :key => 'value' }
    #
    def <<(hsh)
      hsh.each do |k, v|
        # Cast value to string.
        v = v.is_a?(Array) ? v.join(',') : v.to_s

        # Remove whitespace after commas.
        v.gsub!(/,\s+/, ',')

        # Camelize key.
        k = k.to_s.
              split('_').
              map { |w| w[0, 1] = w[0, 1].upcase; w }.
              join

        @params[k] = v
      end

      self
    end

    # Performs a request
    #
    # @return [Vacuum::Response] a response
    def get
      res = Net::HTTP.get_response(url)

      Response.new(res.body, res.code)
    end

    # @return [Hash] the request parameters
    # @raise [Vacuum::MissingKey] Amazon key is missing
    # @raise [Vacuum::MissingTag] Amazon associate tag is
    # missing
    def params
      { 'AWSAccessKeyId' => @locale.key,
        'AssociateTag'   => @locale.tag,
        'Service'        => 'AWSECommerceService',
        'Timestamp'      => timestamp,
        'Version'        => CURRENT_API_VERSION }.merge(@params)
    end

    # Resets the request parameters
    #
    # @return [Vacuum::Request] the request object
    def reset!
      @params = {}

      self
    end

    # @raise [Vacuum::MissingSecret] Amazon secret is missing
    # @return [URI::HTTP] the URL for the API request
    def url
      URI::HTTP.build(:host  => @locale.host,
                      :path  => '/onca/xml',
                      :query => sign(query))
    end

    private

    def escape(value)
      value.gsub(/([^a-zA-Z0-9_.~-]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end
    end

    def query
      params.sort.map { |k, v| "#{k}=" + escape(v) }.join('&')
    end

    def sign(unsigned_query)
      digest = OpenSSL::Digest::Digest.new('sha256')
      url_string = ['GET',
                    @locale.host,
                    '/onca/xml',
                    unsigned_query].join("\n")
      hmac = OpenSSL::HMAC.digest(digest, @locale.secret, url_string)
      signature = escape([hmac].pack('m').chomp)

      "#{unsigned_query}&Signature=#{signature}"
    end

    def timestamp
      Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
    end
  end
end
