# frozen_string_literal: true

module Vacuum
  # The target Amazon locale
  # @api private
  class Locale
    class NotFound < ArgumentError; end

    attr_reader :code, :host, :region

    def self.find(code)
      code = code.to_sym.downcase
      code = :gb if code == :uk

      @all.find { |locale| locale.code == code } || raise(NotFound)
    end

    def initialize(code, host, region)
      @code = code
      @host = host
      @region = region
    end

    def build_url(operation)
      "https://#{host}/paapi5/#{operation.downcase}"
    end

    # https://webservices.amazon.com/paapi5/documentation/common-request-parameters.html#host-and-region
    @all = [
      [:au, 'webservices.amazon.com.au', 'us-west-2'],
      [:br, 'webservices.amazon.com.br', 'us-east-1'],
      [:ca, 'webservices.amazon.ca', 'us-east-1'],
      [:fr, 'webservices.amazon.fr', 'eu-west-1'],
      [:de, 'webservices.amazon.de', 'eu-west-1'],
      [:in, 'webservices.amazon.in', 'eu-west-1'],
      [:it, 'webservices.amazon.it', 'eu-west-1'],
      [:jp, 'webservices.amazon.co.jp', 'us-west-2'],
      [:mx, 'webservices.amazon.com.mx', 'us-east-1'],
      [:es, 'webservices.amazon.es', 'eu-west-1'],
      [:tr, 'webservices.amazon.com.tr', 'eu-west-1'],
      [:ae, 'webservices.amazon.ae', 'eu-west-1'],
      [:gb, 'webservices.amazon.co.uk', 'eu-west-1'],
      [:us, 'webservices.amazon.com', 'us-east-1']
    ].map { |attributes| new(*attributes) }
  end
end
