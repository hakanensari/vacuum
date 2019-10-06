# frozen_string_literal: true

require 'vacuum/response'
require 'httpi'
require 'aws-sigv4'

module Vacuum
  # An Amazon Product Advertising API request.
  class Request
    SERVICE = 'ProductAdvertisingAPI'

    attr_accessor :res
    attr_reader :access_key, :secret_key, :market, :partner_tag

    def initialize(access_key:,
                   secret_key:,
                   partner_tag:,
                   market: :us,
                   resources: nil)
      validate_resources(resources)

      @access_key = access_key
      @secret_key = secret_key
      @partner_tag = partner_tag
      @market = market
    end

    def get_items(item_ids:, resources: nil)
      validate_resources(resources)

      body = { ItemIds: Array(item_ids), Resources: res }

      request('GetItems', body)
    end

    def get_variations(asin:, resources: nil)
      validate_resources(resources)

      body = { ASIN: asin, Resources: res }

      request('GetVariations', body)
    end

    private

    def request(operation, body)
      raise ArgumentError unless OPERATIONS.include?(operation)

      body = default_body.merge(body).to_json
      signature = sign(operation, body)
      request = HTTPI::Request.new(
        headers: request_headers(operation, signature),
        url: marketplace.endpoint(operation),
        body: body
      )

      Response.new HTTPI.post(request)
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
        'PartnerType' => 'Associates',
        'Marketplace' => marketplace.site
      }
    end

    def marketplace
      MARKETPLACES[market]
    end

    def request_headers(operation, signature)
      headers(operation).merge(
        'Content-Type' => 'application/json; charset=utf-8',
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

    def validate_resources(resources)
      return unless resources

      raise ArgumentError unless resources.is_a?(Array)
      raise ArgumentError unless (resources - RESOURCES).empty?

      @res = resources
    end
  end
end
