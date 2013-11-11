require 'jeff'
require 'vacuum/response'

module Vacuum
  # An Amazon Product Advertising API request.
  class Request
    include Jeff

    BadLocale  = Class.new(ArgumentError)

    HOSTS = {
      'CA' => 'webservices.amazon.ca',
      'CN' => 'webservices.amazon.cn',
      'DE' => 'webservices.amazon.de',
      'ES' => 'webservices.amazon.es',
      'FR' => 'webservices.amazon.fr',
      'IN' => 'webservices.amazon.in',
      'IT' => 'webservices.amazon.it',
      'JP' => 'webservices.amazon.co.jp',
      'GB' => 'webservices.amazon.co.uk',
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
    def initialize(locale = nil, secure = false)
      host = HOSTS[locale || 'US'] or raise BadLocale
      self.aws_endpoint = "#{secure ? 'https' : 'http' }://#{host}/onca/xml"
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

    OPERATIONS.each do |operation|
      method_name = operation.gsub(/(.)([A-Z])/,'\1_\2').downcase
      define_method(method_name) do |params, excon_options = {}|
        Response.new(get(excon_options.merge(query: params.merge('Operation' => operation))))
      end
    end

    # Build a URL.
    #
    # params - A Hash of Amazon Product Advertising request parameters.
    #
    # Returns the built URL String.
    def url(params)
      options = { method: :get, query: params }
      [aws_endpoint, build_options(options).fetch(:query)].join('?')
    end
  end
end
