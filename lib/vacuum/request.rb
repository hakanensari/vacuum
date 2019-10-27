# frozen_string_literal: true

require 'aws-sigv4'
require 'httpi'
require 'json'

require 'vacuum/locale'
require 'vacuum/response'

module Vacuum
  # A request to the API
  class Request
    SERVICE = 'ProductAdvertisingAPI'

    attr_reader :access_key, :secret_key, :locale, :partner_tag, :partner_type

    def initialize(marketplace: 'US', access_key:, secret_key:, partner_tag:,
                   partner_type: 'Associates')
      @locale = Locale.find(marketplace)
      @access_key = access_key
      @secret_key = secret_key
      @partner_tag = partner_tag
      @partner_type = partner_type
    end

    def get_browse_nodes(**params)
      request('GetBrowseNodes', params)
    end

    def get_items(**params)
      request('GetItems', params)
    end

    def get_variations(**params)
      request('GetVariations', params)
    end

    def search_items(**params)
      request('SearchItems', params)
    end

    private

    def request(operation, params)
      body = build_body(params)
      signature = sign(operation, body)

      request = HTTPI::Request.new(
        headers: request_headers(operation, signature),
        url: locale.build_url(operation),
        body: body
      )

      Response.new(HTTPI.post(request))
    end

    def sign(operation, body)
      signer.sign_request(
        http_method: 'POST',
        url: locale.build_url(operation),
        headers: headers(operation),
        body: body
      )
    end

    def request_headers(operation, signature)
      headers(operation).merge(
        'Content-Type' => 'application/json; charset=utf-8',
        'Authorization' => signature.headers['authorization'],
        'X-Amz-Content-Sha256' => signature.headers['x-amz-content-sha256'],
        'X-Amz-Date' => signature.headers['x-amz-date'],
        'Host' => locale.endpoint
      )
    end

    def headers(operation)
      {
        'X-Amz-Target' => "com.amazon.paapi5.v1.#{SERVICE}v1.#{operation}",
        'Content-Encoding' => 'amz-1.0'
      }
    end

    def signer
      ::Aws::Sigv4::Signer.new(
        service: SERVICE,
        region: locale.region,
        access_key_id: access_key,
        secret_access_key: secret_key,
        http_method: 'POST',
        endpoint: locale.endpoint
      )
    end

    def build_body(params)
      hsh = { 'PartnerTag' => partner_tag,
              'PartnerType' => partner_type }

      params.each do |key, val|
        key = key.to_s.split('_')
                 .map { |word| word == 'asin' ? 'ASIN' : word.capitalize }.join
        hsh[key] = val
      end

      JSON.generate(hsh)
    end
  end
end
