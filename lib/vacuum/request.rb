# frozen_string_literal: true

require 'httpi'
require 'aws-sigv4'

module Vacuum
  class Request
    Market = Struct.new(:host, :region) do
      def site
        host.sub('webservices', 'www')
      end

      def endpoint(operation)
        "https://#{host}/paapi5/#{operation.downcase}"
      end
    end

    MARKETPLACES = {
      au: Market.new('webservices.amazon.com.au', 'us-west-2'),
      br: Market.new('webservices.amazon.com.br', 'us-east-1'),
      ca: Market.new('webservices.amazon.ca',     'us-east-1'),
      fr: Market.new('webservices.amazon.fr',     'eu-west-1'),
      de: Market.new('webservices.amazon.de',     'eu-west-1'),
      in: Market.new('webservices.amazon.in',     'eu-west-1'),
      it: Market.new('webservices.amazon.it',     'eu-west-1'),
      jp: Market.new('webservices.amazon.co.jp',  'us-west-2'),
      mx: Market.new('webservices.amazon.com.mx', 'us-east-1'),
      es: Market.new('webservices.amazon.es',     'eu-west-1'),
      tr: Market.new('webservices.amazon.com.tr', 'eu-west-1'),
      ae: Market.new('webservices.amazon.ae',     'eu-west-1'),
      uk: Market.new('webservices.amazon.co.uk',  'eu-west-1'),
      us: Market.new('webservices.amazon.com',    'us-east-1')
    }.freeze

    OPERATIONS = %w[
      GetBrowseNodes
      GetItems
      GetVariations
      SearchItems
    ].freeze

    attr_reader :access_key, :secret_key, :market, :partner_tag

    def initialize(access_key:,
                   secret_key:,
                   partner_tag:,
                   market: :us)
      @access_key = access_key
      @secret_key = secret_key
      @partner_tag = partner_tag
      @market = market
    end

    def get_items(item_ids:, resources:)
      body = { ItemIds: Array(item_ids), Resources: resources }

      request('GetItems', body)
    end

    def get_variations(asin:, resources:)
      body = { ASIN: asin, Resources: resources }

      request('GetVariations', body)
    end

    private

    def request(operation, body)
      raise ArguemntError unless OPERATIONS.include?(operation)

      marketplace = MARKETPLACES[market]

      body = {
        'PartnerTag' => partner_tag,
        'PartnerType' => 'Associates',
        'Marketplace' => marketplace.site
      }.merge(body).to_json

      headers = {
        'X-Amz-Target' => "com.amazon.paapi5.v1.ProductAdvertisingAPIv1.#{operation}",
        'Content-Encoding' => 'amz-1.0'
      }

      signer = Aws::Sigv4::Signer.new(
        service: 'ProductAdvertisingAPI',
        region: marketplace.region,
        access_key_id: access_key,
        secret_access_key: secret_key,
        http_method: 'POST',
        endpoint: marketplace.host
      )

      signature = signer.sign_request(
        http_method: 'POST',
        url: marketplace.endpoint(operation),
        headers: headers,
        body: body
      )

      headers = headers.dup.merge(
        'Content-Type' => 'application/json; charset=utf-8',
        'Authorization' => signature.headers['authorization'],
        'X-Amz-Content-Sha256' => signature.headers['x-amz-content-sha256'],
        'X-Amz-Date' => signature.headers['x-amz-date'],
        'Host' => marketplace.host
      )

      request = HTTPI::Request.new(
        headers: headers,
        url: marketplace.endpoint(operation),
        body: body
      )

      HTTPI.post(request)
    end
  end
end
