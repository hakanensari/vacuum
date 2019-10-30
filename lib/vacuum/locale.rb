# frozen_string_literal: true

module Vacuum
  # The target Amazon locale
  # @api private
  class Locale
    class NotFound < ArgumentError; end

    attr_reader :code, :domain, :region

    def self.find(code)
      code = code.to_sym.downcase
      code = :gb if code == :uk

      @all.find { |locale| locale.code == code } || raise(NotFound)
    end

    def initialize(code, domain, region)
      @code = code
      @domain = domain
      @region = region
    end

    def endpoint
      "webservices.#{domain}"
    end

    def marketplace
      "www.#{domain}"
    end

    def build_url(operation)
      "https://#{endpoint}/paapi5/#{operation.downcase}"
    end

    @all = [
      [:au, 'amazon.com.au', 'us-west-2'],
      [:br, 'amazon.com.br', 'us-east-1'],
      [:ca, 'amazon.ca', 'us-east-1'],
      [:fr, 'amazon.fr', 'eu-west-1'],
      [:de, 'amazon.de', 'eu-west-1'],
      [:in, 'amazon.in', 'eu-west-1'],
      [:it, 'amazon.it', 'eu-west-1'],
      [:jp, 'amazon.co.jp', 'us-west-2'],
      [:mx, 'amazon.com.mx', 'us-east-1'],
      [:es, 'amazon.es', 'eu-west-1'],
      [:tr, 'amazon.com.tr', 'eu-west-1'],
      [:ae, 'amazon.ae', 'eu-west-1'],
      [:gb, 'amazon.co.uk', 'eu-west-1'],
      [:us, 'amazon.com', 'us-east-1']
    ].map { |attributes| new(*attributes) }
  end
end
