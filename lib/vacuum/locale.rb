# frozen_string_literal: true

module Vacuum
  # The target Amazon Locale
  class Locale
    NotFound = Class.new(ArgumentError)

    attr_reader :country_code, :endpoint, :region

    def self.find(country_code)
      code = country_code.to_s.upcase
      code = 'GB' if code == 'UK'

      @all.find { |locale| locale.country_code == code } || raise(NotFound)
    end

    def initialize(country_code, endpoint, region)
      @country_code = country_code
      @endpoint = endpoint
      @region = region
    end

    def marketplace
      endpoint.sub('webservices', 'www')
    end

    def build_url(operation)
      "https://#{endpoint}/paapi5/#{operation.downcase}"
    end

    @all = [
      %w[AU webservices.amazon.com.au us-west-2],
      %w[BR webservices.amazon.com.br us-east-1],
      %w[CA webservices.amazon.ca us-east-1],
      %w[FR webservices.amazon.fr eu-west-1],
      %w[DE webservices.amazon.de eu-west-1],
      %w[IN webservices.amazon.in eu-west-1],
      %w[IT webservices.amazon.it eu-west-1],
      %w[JP webservices.amazon.co.jp us-west-2],
      %w[MX webservices.amazon.com.mx us-east-1],
      %w[ES webservices.amazon.es eu-west-1],
      %w[TR webservices.amazon.com.tr eu-west-1],
      %w[AE webservices.amazon.ae eu-west-1],
      %w[GB webservices.amazon.co.uk eu-west-1],
      %w[US webservices.amazon.com us-east-1]
    ].map { |attributes| new(*attributes) }
  end
end
