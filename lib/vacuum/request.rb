# frozen_string_literal: true

require "http"
require "json"

module Vacuum
  # A request to the Amazon Creators API
  class Request
    # @return [HTTP::Client]
    attr_reader :http

    # @return [String]
    attr_reader :marketplace, :access_token, :version, :partner_tag

    # Creates a new request
    #
    # @param [String] marketplace The marketplace domain (e.g. www.amazon.com)
    # @param [String] access_token
    # @param [String] version
    # @param [String] partner_tag
    # @param [HTTP::Client] http
    def initialize(marketplace:, access_token:, version:, partner_tag:, http: HTTP)
      @marketplace = marketplace
      @access_token = access_token
      @version = version
      @partner_tag = partner_tag
      @http = http
    end

    # Returns details about specified browse nodes
    #
    # @overload get_browse_nodes(browse_node_ids:, languages_of_preference: nil, marketplace: nil, partner_tag: nil, resources: nil)
    #   @param [Array<String,Integer>,String,Integer] browse_node_ids
    #   @param [Array<String>,nil] languages_of_preference
    #   @param [String,nil] marketplace
    #   @param [String,nil] partner_tag
    #   @param [Array<String>,nil] resources
    # @return [Response]
    def get_browse_nodes(browse_node_ids:, **params)
      params.update(browse_node_ids: Array(browse_node_ids))
      request("GetBrowseNodes", params)
    end

    # Returns the attributes of one or more items
    #
    # @overload get_items(condition: nil, currency_of_preference: nil, item_id_type: nil, item_ids:, languages_of_preference: nil, marketplace: nil, merchant: nil, partner_tag: nil, resources: nil)
    #   @param [String,nil] condition
    #   @param [String,nil] currency_of_preference
    #   @param [String,nil] item_id_type
    #   @param [Array<String>,String] item_ids
    #   @param [Array<String>,nil] languages_of_preference
    #   @param [String,nil] marketplace
    #   @param [String,nil] merchant
    #   @param [String,nil] partner_tag
    #   @param [Array<String>,nil] resources
    # @return [Response]
    def get_items(item_ids:, **params)
      params.update(item_ids: Array(item_ids))
      request("GetItems", params)
    end

    # Returns a set of items that are the same product, but differ according to
    # a consistent theme
    #
    # @overload get_variations(asin:, condition: nil, currency_of_preference: nil, languages_of_preference: nil, marketplace: nil, merchant: nil, partner_tag: nil, resources: nil, variation_count: nil, variation_page: nil)
    #   @param [String] asin
    #   @param [String,nil] condition
    #   @param [String,nil] currency_of_preference
    #   @param [Array<String>,nil] languages_of_preference
    #   @param [String,nil] marketplace
    #   @param [String,nil] merchant
    #   @param [String,nil] partner_tag
    #   @param [Array<String>,nil] resources
    #   @param [Integer,nil] variation_count
    #   @param [Integer,nil] variation_page
    #   @return [Response]
    def get_variations(**params)
      request("GetVariations", params)
    end

    # Searches for items on Amazon based on a search query
    #
    # @overload search_items(actor: nil, artist: nil, author: nil, availability: nil, brand: nil, browse_node_id: nil, condition: nil, currency_of_preference: nil, delivery_flags: nil, item_count: nil, item_page: nil, keywords: nil, languages_of_preference: nil, marketplace: nil, max_price: nil, merchant: nil, min_price: nil, min_reviews_rating: nil, min_savings_percent: nil, partner_tag: nil, resources: nil, search_index: nil, sort_by: nil, title: nil)
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
    #   @param [Hash,nil] properties
    #   @param [Array<String>,nil] resources
    #   @param [String,nil] search_index
    #   @param [String,nil] sort_by
    #   @param [String,nil] title
    # @return [Response]
    def search_items(**params)
      request("SearchItems", params)
    end

    private

    def request(operation_name, params)
      http.headers(headers).post(url(operation_name), body: body(params))
    end

    def headers
      {
        "Authorization" => "Bearer #{access_token}, Version #{version}",
        "Content-Type" => "application/json",
        "x-marketplace" => marketplace,
      }
    end

    def url(operation_name)
      # GetItems -> getItems
      name = operation_name[0].downcase + operation_name[1..]
      "https://creatorsapi.amazon/catalog/v1/#{name}"
    end

    def body(params)
      hsh = { "partnerTag" => partner_tag, "marketplace" => marketplace }

      params.each do |key, val|
        camel_key = key.to_s.gsub(/_([a-z])/) { ::Regexp.last_match(1).upcase }
        hsh[camel_key] = val
      end

      JSON.generate(hsh)
    end
  end
end
