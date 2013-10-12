require 'jeff'

module Vacuum
  # An Amazon Product Advertising API request.
  class Request
    include Jeff

    BadLocale  = Class.new(ArgumentError)

    # A list of Amazon Product Advertising API hosts.
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

    params 'AssociateTag' => -> { associate_tag },
           'Service'      => 'AWSECommerceService',
           'Version'      => '2011-08-01'

    # Create a new request for given locale.
    #
    # locale - The String Product Advertising API locale (default: US).
    #
    # Raises a Bad Locale error if locale is not valid.
    def initialize(locale = nil)
      if locale == 'UK'
        warn '[DEPRECATION] Use GB instead of UK'
        locale = 'GB'
      end

      host = HOSTS[locale || 'US'] or raise BadLocale
      self.aws_endpoint = "http://#{host}/onca/xml"
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

    # Get/Sets the String Associate Tag.
    attr_accessor :associate_tag
    # Keep around old attribute for a while for backward compatibility.
    alias :tag :associate_tag
    alias :tag= :associate_tag=

    # Build a URL.
    #
    # params - A Hash of Amazon Product Advertising query params.
    #
    # Returns the built URL String.
    def url(params)
      opts = {
        method: :get,
        query:  params
      }

      [aws_endpoint, build_options(opts).fetch(:query)].join('?')
    end
  end
end
