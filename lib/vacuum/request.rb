require 'jeff'

module Vacuum
  # An Amazon Product Advertising API request.
  class Request
    include Jeff

    BadLocale  = Class.new ArgumentError
    MissingTag = Class.new ArgumentError

    # A list of Amazon Product Advertising API hosts.
    HOSTS = {
      'CA' => 'ecs.amazonaws.ca',
      'CN' => 'webservices.amazon.cn',
      'DE' => 'ecs.amazonaws.de',
      'ES' => 'webservices.amazon.es',
      'FR' => 'ecs.amazonaws.fr',
      'IT' => 'webservices.amazon.it',
      'JP' => 'ecs.amazonaws.jp',
      'UK' => 'ecs.amazonaws.co.uk',
      'US' => 'ecs.amazonaws.com'
    }.freeze

    params 'AssociateTag' => -> { tag },
           'Service'      => 'AWSECommerceService',
           'Version'      => '2011-08-01'

    # Creates a new request for given locale and credentials.
    #
    # locale - The String Product Advertising API locale (default: US).
    #
    # Raises a Bad Locale error if locale is not valid.
    def initialize(locale = nil)
      host = HOSTS[locale || 'US'] or raise BadLocale
      self.endpoint = "http://#{host}/onca/xml"
    end

    # Configures the Amazon Product Advertising API request.
    #
    # credentials - The Hash credentials of the API endpoint.
    #               :key    - The String Amazon Web Services (AWS) key.
    #               :secret - The String AWS secret.
    #               :tag    - The String Associate Tag.
    #
    # Returns nothing.
    def configure(credentials)
      credentials.each { |key, val| self.send "#{key}=", val }
    end

    # Gets the String Associate Tag.
    #
    # Raises a Missing Tag error if Associate Tag is missing.
    def tag
      @tag or raise MissingTag
    end

    # Sets the String Associate Tag.
    attr_writer :tag
  end
end
