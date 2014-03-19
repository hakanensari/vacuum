require 'jeff'
require 'vacuum/response'

module Vacuum
  # An Amazon Product Advertising API request.
  class Request
    include Jeff

    BadLocale  = Class.new(ArgumentError)

    HOSTS = {
      'BR' => 'webservices.amazon.com.br',
      'CA' => 'webservices.amazon.ca',
      'CN' => 'webservices.amazon.cn',
      'DE' => 'webservices.amazon.de',
      'ES' => 'webservices.amazon.es',
      'FR' => 'webservices.amazon.fr',
      'GB' => 'webservices.amazon.co.uk',
      'IN' => 'webservices.amazon.in',
      'IT' => 'webservices.amazon.it',
      'JP' => 'webservices.amazon.co.jp',
      'US' => 'webservices.amazon.com'
    }.freeze

    OPERATIONS = %w(
      BrowseNodeLookup
      CartAdd
      CartClear
      CartCreate
      CartGet
      CartModify
      ItemLookup
      ItemSearch
      SimilarityLookup
    ).freeze

    params 'AssociateTag' => -> { associate_tag },
           'Service'      => 'AWSECommerceService',
           'Version'      => '2011-08-01'

    attr_accessor :associate_tag

    # Create a new request for given locale.
    #
    # locale - The String Product Advertising API locale (default: US).
    # secure - Whether to use the secure version of the endpoint (default:
    #          false)
    #
    # Raises a Bad Locale error if locale is not valid.
    def initialize(locale = 'US', secure = false)
      host = HOSTS.fetch(locale) { raise BadLocale }
      @aws_endpoint = "#{secure ? 'https' : 'http' }://#{host}/onca/xml"
    end

    # Configure the Amazon Product Advertising API request.
    #
    # credentials - The Hash credentials of the API endpoint.
    #               :aws_access_key_id     - The String Amazon Web Services
    #                                        (AWS) key.
    #               :aws_secret_access_key - The String AWS secret.
    #               :associate_tag         - The String Associate Tag.
    #
    # Returns self.
    def configure(credentials)
      credentials.each { |key, val| self.send("#{key}=", val) }
      self
    end

    # Execute an API operation. See `OPERATIONS` constant for available
    # operation names.
    #
    # params - The Hash request parameters.
    # opts   - Options passed to Excon (default: {}).
    #
    # Alternatively, pass Excon options as first argument and include request
    # parameters as query key.
    #
    # Examples
    #
    #   req.item_search(
    #     'SearchIndex' => 'All',
    #     'Keywords' => 'Architecture'
    #   )
    #
    #   req.item_search(
    #     query: {
    #       'SearchIndex' => 'All',
    #       'Keywords' => 'Architecture'
    #     },
    #     persistent: true
    #   )
    #
    # Returns a Vacuum Response.
    OPERATIONS.each do |operation|
      method_name = operation.gsub(/(.)([A-Z])/,'\1_\2').downcase
      define_method(method_name) do |params, opts = {}|
        params.has_key?(:query) ? opts = params : opts.update(query: params)
        opts[:query].update('Operation' => operation)

        Response.new(get(opts))
      end
    end
  end
end
