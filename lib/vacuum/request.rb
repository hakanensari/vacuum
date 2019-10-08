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

    def get_items(item_ids:, resources: nil)
      @res = resources if resources

      body = { ItemIds: Array(item_ids), Resources: res }

      request('GetItems', body)
    end

    def get_variations(asin:, resources: nil)
      @res = resources if resources

      body = { ASIN: asin, Resources: res }

      request('GetVariations', body)
    end

    private

    def request(operation, body)
      raise ArgumentError unless OPERATIONS.include?(operation)

      body = default_body.merge(body).to_json
      signature = sign(operation, body)
      uri = URI.parse(marketplace.endpoint(operation))
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json; charset=UTF-8"
      request_headers(operation, signature).each do |key, value|
        request[key] = value
      end
      request.body = body

      req_options = {
        use_ssl: uri.scheme == "https"
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
        'Marketplace' => marketplace.site
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
