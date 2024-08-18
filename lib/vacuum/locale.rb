# frozen_string_literal: true

module Vacuum
  # The target locale
  #
  # @see https://webservices.amazon.com/paapi5/documentation/common-request-parameters.html#host-and-region
  class Locale
    # Raised when the provided marketplace does not correspond to an existing
    # Amazon locale
    class NotFound < KeyError; end

    HOSTS_AND_REGIONS = {
      au: ['webservices.amazon.com.au', 'us-west-2'],
      be: ['webservices.amazon.be', 'eu-west-1'],
      br: ['webservices.amazon.com.br', 'us-east-1'],
      ca: ['webservices.amazon.ca', 'us-east-1'],
      eg: ['webservices.amazon.eg', 'eu-west-1'],
      fr: ['webservices.amazon.fr', 'eu-west-1'],
      de: ['webservices.amazon.de', 'eu-west-1'],
      in: ['webservices.amazon.in', 'eu-west-1'],
      it: ['webservices.amazon.it', 'eu-west-1'],
      jp: ['webservices.amazon.co.jp', 'us-west-2'],
      mx: ['webservices.amazon.com.mx', 'us-east-1'],
      nl: ['webservices.amazon.nl', 'eu-west-1'],
      pl: ['webservices.amazon.pl', 'eu-west-1'],
      sg: ['webservices.amazon.sg', 'us-west-2'],
      sa: ['webservices.amazon.sa', 'eu-west-1'],
      es: ['webservices.amazon.es', 'eu-west-1'],
      se: ['webservices.amazon.se', 'eu-west-1'],
      tr: ['webservices.amazon.com.tr', 'eu-west-1'],
      ae: ['webservices.amazon.ae', 'eu-west-1'],
      gb: ['webservices.amazon.co.uk', 'eu-west-1'],
      us: ['webservices.amazon.com', 'us-east-1']
    }.freeze
    private_constant :HOSTS_AND_REGIONS

    # @return [String]
    attr_reader :host, :region, :access_key, :secret_key, :partner_tag,
                :partner_type

    # Creates a locale
    #
    # @param [Symbol,String] marketplace
    # @param [String] access_key
    # @param [String] secret_key
    # @param [String] partner_tag
    # @param [String] partner_type
    # @raise [NotFound] if marketplace is not found
    def initialize(marketplace, access_key:, secret_key:, partner_tag:,
                   partner_type: 'Associates')
      @host, @region = find_host_and_region(marketplace)
      @access_key = access_key
      @secret_key = secret_key
      @partner_tag = partner_tag
      @partner_type = partner_type
    end

    private

    def find_host_and_region(marketplace)
      marketplace = marketplace.to_sym.downcase
      marketplace = :gb if marketplace == :uk

      HOSTS_AND_REGIONS.fetch(marketplace)
    rescue KeyError
      raise NotFound, "marketplace not found: :#{marketplace}"
    end
  end
end
