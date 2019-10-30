# frozen_string_literal: true

require 'aws-sigv4'
require 'httpi'
require 'json'

require 'vacuum/locale'
require 'vacuum/response'

module Vacuum
  # A request to the Amazon Product Advertising API
  class Request
    SERVICE = 'ProductAdvertisingAPI'
    private_constant :SERVICE

    # @api private
    attr_reader :access_key, :secret_key, :locale, :partner_tag, :partner_type

    # Creates a new request
    # @param [Symbol,String] marketplace the two-letter country code of the
    #   target Amazon locale
    # @param [String] access_key your access key
    # @param [String] secret_key your secret key
    # @param [String] partner_tag your partner tag
    # @param [String] partner_type your partner type
    def initialize(marketplace: :us, access_key:, secret_key:, partner_tag:,
                   partner_type: 'Associates')
      @locale = Locale.find(marketplace)
      @access_key = access_key
      @secret_key = secret_key
      @partner_tag = partner_tag
      @partner_type = partner_type
    end

    # Returns details about specified browse nodes
    # @see https://webservices.amazon.com/paapi5/documentation/getbrowsenodes.html
    # @overload get_browse_nodes(browse_node_ids:, languages_of_preference: nil, marketplace: nil, partner_tag: nil, partner_type: nil, resources: nil)
    #   @param [Array<String,Integer>,String,Integer] browse_node_ids
    #   @param [Array<String>,nil] languages_of_preference
    #   @param [String,nil] marketplace
    #   @param [String,nil] partner_tag
    #   @param [String,nil] partner_type
    #   @param [Array<String>,nil] resources
    # @return [Response]
    def get_browse_nodes(browse_node_ids:, **params)
      params.update(browse_node_ids: Array(browse_node_ids))
      request('GetBrowseNodes', params)
    end

    # Returns the attributes of one or more items
    # @see https://webservices.amazon.com/paapi5/documentation/get-items.html
    # @overload get_items(condition: nil, currency_of_preference: nil, item_id_type: nil, item_ids:, languages_of_preference: nil, marketplace: nil, merchant: nil, offer_count: nil, partner_tag: nil, partner_type: nil, resources: nil)
    #   @param [String,nil] condition
    #   @param [String,nil] currency_of_preference
    #   @param [String,nil] item_id_type
    #   @param [Array<String>,String] item_ids
    #   @param [Array<String>,nil] languages_of_preference
    #   @param [String,nil] marketplace
    #   @param [String,nil] merchant
    #   @param [Integer,nil] offer_count
    #   @param [String,nil] partner_tag
    #   @param [String,nil] partner_type
    #   @param [Array<String>,nil] resources
    # @return [Response]
    def get_items(item_ids:, **params)
      params.update(item_ids: Array(item_ids))
      request('GetItems', params)
    end

    # Returns a set of items that are the same product, but differ according to
    # a consistent theme
    # @see https://webservices.amazon.com/paapi5/documentation/get-variations.html
    # @overload get_variations(asin:, condition: nil, currency_of_preference: nil, languages_of_preference: nil, marketplace: nil, merchant: nil, offer_count: nil, partner_tag: nil, partner_type: nil, resources: nil, variation_count: nil, variation_page: nil)
    #   @param [String] asin
    #   @param [String,nil] condition
    #   @param [String,nil] currency_of_preference
    #   @param [Array<String>,nil] languages_of_preference
    #   @param [String,nil] marketplace
    #   @param [String,nil] merchant
    #   @param [Integer,nil] offer_count
    #   @param [String,nil] partner_tag
    #   @param [String,nil] partner_type
    #   @param [Array<String>,nil] resources
    #   @param [Integer,nil] variation_count
    #   @param [Integer,nil] variation_page
    #   @return [Response]
    def get_variations(**params)
      request('GetVariations', params)
    end

    # Searches for items on Amazon based on a search query
    # @see https://webservices.amazon.com/paapi5/documentation/search-items.html
    # @overload search_items(actor: nil, artist: nil, author: nil, availability: nil, brand: nil, browse_node_id: nil, condition: nil, currency_of_preference: nil, delivery_flags: nil, item_count: nil, item_page: nil, keywords: nil, languages_of_preference: nil, marketplace: nil, max_price: nil, merchant: nil, min_price: nil, min_reviews_rating: nil, min_savings_percent: nil, offer_count: nil, partner_tag: nil, partner_type: nil, resources: nil, search_index: nil, sort_by: nil, title: nil)
    #   @param [String,nil] actor
    #   @param [String,nil] artist
    #   @param [String,nil] availability
    #   @param [String,nil] brand
    #   @param [Integer,nil] browse_node_id
    #   @param [String,nil] condition
    #   @param [String,nil] currency_of_preference
    #   @param [Array<String>,nil] delivery_flags
    #   @param [Integer,nil] item_count
    #   @param [Integer,nil] item_page
    #   @param [String,nil] keywords
    #   @param [Array<String>,nil] languages_of_preference
    #   @param [Integer,nil] max_price
    #   @param [String,nil] merchant
    #   @param [Integer,nil] min_price
    #   @param [Integer,nil] min_reviews_rating
    #   @param [Integer,nil] min_savings_percent
    #   @param [Integer,nil] offer_count
    #   @param [Hash,nil] properties
    #   @param [Array<String>,nil] resources
    #   @param [String,nil] search_index
    #   @param [String,nil] sort_by
    #   @param [String,nil] title
    # @return [Response]
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
      Aws::Sigv4::Signer.new(
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
