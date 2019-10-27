# frozen_string_literal: true

module Vacuum
  # The target Amazon Locale
  class Locale
    NotFound = Class.new(ArgumentError)

    attr_reader :code, :host, :region

    def self.find(code)
      code = code.to_s.upcase
      code = 'GB' if code == 'UK'

      @all.find { |locale| locale.code == code } || raise(NotFound)
    end

    def initialize(code, host, region)
      @code = code
      @host = host
      @region = region
    end

    def endpoint
      "webservices.#{host}"
    end

    def marketplace
      "www.#{host}"
    end

    def build_url(operation)
      "https://#{endpoint}/paapi5/#{operation.downcase}"
    end

    @all = [
      %w[AU amazon.com.au us-west-2],
      %w[BR amazon.com.br us-east-1],
      %w[CA amazon.ca us-east-1],
      %w[FR amazon.fr eu-west-1],
      %w[DE amazon.de eu-west-1],
      %w[IN amazon.in eu-west-1],
      %w[IT amazon.it eu-west-1],
      %w[JP amazon.co.jp us-west-2],
      %w[MX amazon.com.mx us-east-1],
      %w[ES amazon.es eu-west-1],
      %w[TR amazon.com.tr eu-west-1],
      %w[AE amazon.ae eu-west-1],
      %w[GB amazon.co.uk eu-west-1],
      %w[US amazon.com us-east-1]
    ].map { |attributes| new(*attributes) }
  end
end
