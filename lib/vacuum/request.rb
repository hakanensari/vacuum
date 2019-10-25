# frozen_string_literal: true

require 'vacuum/response'
require 'vacuum/adapter'
require 'aws-sigv4'

module Vacuum
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

    BROWSE_NODES_RESORCES = [
      'BrowseNodes.Ancestor',
      'BrowseNodes.Children'
    ].freeze

    def get_browse_nodes(browse_node_ids:, **options)
      @marketplace = options[:marketplace] if options[:marketplace]
      body = param_builder(
        { BrowseNodeIds: Array(browse_node_ids) },
        options.merge(resources: BROWSE_NODES_RESORCES)
      )

      request('GetBrowseNodes', body)
    end

    def get_items(item_ids:, **options)
      @marketplace = options[:marketplace] if options[:marketplace]
      body = param_builder({ ItemIds: Array(item_ids) }, options)

      request('GetItems', body)
    end

    def get_variations(asin:, **options)
      @marketplace = options[:marketplace] if options[:marketplace]
      body = param_builder({ ASIN: asin }, options)

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

    def param_builder(body, params)
      body.tap do |hsh|
        # REQUIRED
        hsh['PartnerTag'] = params[:partner_tag] || partner_tag
        hsh['PartnerType'] = params[:partner_type] || partner_type
        hsh['Marketplace'] = market.site
        hsh['Resources'] = params[:resources] || res

        params.each do |key, val|
          hsh[key.to_s.split('_').map(&:capitalize).join] = val
        end

        # OPTIONAL_PARAMS.keys.each do |key|
        #   hsh[OPTIONAL_PARAMS[key]] = params[key] if params[key]
        # end
      end.to_json
    end
  end
end
