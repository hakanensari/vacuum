# frozen_string_literal: true

require 'vacuum/response'
require 'vacuum/adapter'
require 'aws-sigv4'

module Vacuum
  BadLocale = Class.new(ArgumentError)
  # An Amazon Product Advertising API request.
  class Request
    SERVICE = 'ProductAdvertisingAPI'

    attr_accessor :res
    attr_reader :access_key, :secret_key, :marketplace,
                :partner_tag, :partner_type

    def initialize(access_key:,
                   secret_key:,
                   partner_tag:,
                   marketplace: :us,
                   partner_type: 'Associates',
                   resources: nil)
      @res = resources if resources
      @access_key = access_key
      @secret_key = secret_key
      @partner_tag = partner_tag
      @partner_type = partner_type
      @marketplace = marketplace
    end

    def get_browse_nodes(browse_node_ids:,
                         languages_of_preference: nil,
                         marketplace: nil)
      @res = ['BrowseNodes.Ancestor', 'BrowseNodes.Children']
      @marketplace = marketplace if marketplace

      body = {}.tap do |hsh|
        hsh[:BrowseNodeIds] = Array(browse_node_ids)
        if languages_of_preference
          hsh[:LanguagesOfPreference] = languages_of_preference
        end
      end.to_json

      request('GetBrowseNodes', body)
    end

    def get_items(item_ids:, marketplace: nil, **options)
      @marketplace = marketplace if marketplace
      body = enhance_body({ ItemIds: Array(item_ids) }, options)

      request('GetItems', body)
    end

    def get_variations(asin:, marketplace: nil, **options)
      @marketplace = marketplace if marketplace
      body = enhance_body({ ASIN: asin }, options)

      request('GetVariations', body)
    end

    private

    def request(operation, body)
      signature = sign(operation, body)

      Response.new Adapter.post(
        url: market.endpoint(operation),
        body: body,
        headers: request_headers(operation, signature)
      )
    end

    def sign(operation, body)
      signer.sign_request(
        http_method: 'POST',
        url: market.endpoint(operation),
        headers: headers(operation),
        body: body
      )
    end

    def market
      MARKETPLACES.fetch(marketplace.downcase.to_sym) { |_| raise BadLocale }
    end

    def request_headers(operation, signature)
      headers(operation).merge(
        'Authorization' => signature.headers['authorization'],
        'X-Amz-Content-Sha256' => signature.headers['x-amz-content-sha256'],
        'X-Amz-Date' => signature.headers['x-amz-date'],
        'Host' => market.host
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
        region: market.region,
        access_key_id: access_key,
        secret_access_key: secret_key,
        http_method: 'POST',
        endpoint: market.host
      )
    end

    OPTIONAL_OPTIONS = {
      condition: 'Condition',
      currency_of_preference: 'CurrencyOfPreference',
      languages_of_preference: 'LanguagesOfPreference',
      offer_count: 'OfferCount',
      # ONLY FOR GET_VARIATIONS
      variation_count: 'VariationCount',
      variation_page: 'VariationPage'
    }.freeze

    def enhance_body(body, options)
      body.tap do |hsh|
        # REQUIRED
        hsh[:PartnerTag] = options[:partner_tag] || partner_tag
        hsh[:PartnerType] = options[:partner_type] || partner_type
        hsh[:Marketplace] = market.site
        hsh[:Resources] = options[:resources] || res

        OPTIONAL_OPTIONS.keys.each do |key|
          hsh[OPTIONAL_OPTIONS[key]] = options[key] if options[key]
        end
      end.to_json
    end
  end
end
