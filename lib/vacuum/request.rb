# frozen_string_literal: true

require 'vacuum/response'
require 'net/http'
require 'uri'
require 'aws-sigv4'

module Vacuum
  # An Amazon Product Advertising API request.
  class Request
    SERVICE = 'ProductAdvertisingAPI'

    attr_accessor :res
    attr_reader :access_key, :secret_key, :market, :partner_tag, :partner_type

    def initialize(access_key:,
                   secret_key:,
                   partner_tag:,
                   market: :us,
                   partner_type: 'Associates',
                   resources: nil)
      @res = resources if resources
      @access_key = access_key
      @secret_key = secret_key
      @partner_tag = partner_tag
      @partner_type = partner_type
      @market = market
    end

    def get_items(item_ids:,
                  resources: nil,
                  condition: nil,
                  currency_of_preference: nil,
                  languages_of_preference: nil,
                  market: nil,
                  offer_count: nil)
      @res = resources if resources
      @market = market if market

      body = {}.tap do |hsh|
        hsh[:ItemIds] = Array(item_ids)
        hsh[:Condition] = condition if condition
        if currency_of_preference
          hsh[:CurrencyOfPreference] = currency_of_preference
        end
        if languages_of_preference
          hsh[:LanguagesOfPreference] = languages_of_preference
        end
        hsh[:OfferCount] = offer_count if offer_count
      end

      request('GetItems', body)
    end

    def get_variations(asin:,
                       resources: nil,
                       condition: nil,
                       currency_of_preference: nil,
                       languages_of_preference: nil,
                       market: nil,
                       offer_count: nil,
                       variation_count: nil,
                       variation_page: nil)
      @res = resources if resources
      @market = market if market

      body = {}.tap do |hsh|
        hsh[:ASIN] = asin
        hsh[:Condition] = condition if condition
        if currency_of_preference
          hsh[:CurrencyOfPreference] = currency_of_preference
        end
        if languages_of_preference
          hsh[:LanguagesOfPreference] = languages_of_preference
        end
        hsh[:OfferCount] = offer_count if offer_count
        hsh[:VariationCount] = variation_count if variation_count
        hsh[:VariationPage] = variation_page if variation_page
      end

      request('GetVariations', body)
    end

    private

    def request(operation, body)
      raise ArgumentError unless OPERATIONS.include?(operation)

      body = default_body.merge(body).to_json
      signature = sign(operation, body)
      uri = URI.parse(marketplace.endpoint(operation))
      request = Net::HTTP::Post.new(uri)
      request.content_type = 'application/json; charset=UTF-8'
      request_headers(operation, signature).each do |key, value|
        request[key] = value
      end
      request.body = body

      req_options = {
        use_ssl: uri.scheme == 'https'
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      Response.new response
    end

    def sign(operation, body)
      signer.sign_request(
        http_method: 'POST',
        url: marketplace.endpoint(operation),
        headers: headers(operation),
        body: body
      )
    end

    def default_body
      {
        'PartnerTag' => partner_tag,
        'PartnerType' => partner_type,
        'Marketplace' => marketplace.site,
        'Resources' => res
      }
    end

    def marketplace
      MARKETPLACES[market]
    end

    def request_headers(operation, signature)
      headers(operation).merge(
        'Authorization' => signature.headers['authorization'],
        'X-Amz-Content-Sha256' => signature.headers['x-amz-content-sha256'],
        'X-Amz-Date' => signature.headers['x-amz-date'],
        'Host' => marketplace.host
      )
    end

    def headers(operation)
      {
        'X-Amz-Target' => "com.amazon.paapi5.v1.#{SERVICE}v1.#{operation}",
        'Content-Encoding' => 'amz-1.0'
      }
    end

    def signer
      Aws::Sigv4::Signer.new(
        service: SERVICE,
        region: marketplace.region,
        access_key_id: access_key,
        secret_access_key: secret_key,
        http_method: 'POST',
        endpoint: marketplace.host
      )
    end
  end
end
