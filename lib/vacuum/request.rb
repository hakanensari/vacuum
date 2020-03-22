# frozen_string_literal: true

require 'http'

require 'vacuum/locale'
require 'vacuum/operation'
require 'vacuum/resource'
require 'vacuum/response'

module Vacuum
  # A request to the Amazon Product Advertising API
  class Request
    # @return [HTTP::Client]
    attr_reader :client

    # @return [Locale]
    attr_reader :locale

    # @return [Operation]
    attr_reader :operation

    # Creates a new request
    #
    # @overload initialize(marketplace: :us, access_key:, secret_key:, partner_tag:, partner_type:)
    #   @param [Symbol,String] marketplace
    #   @param [String] access_key
    #   @param [String] secret_key
    #   @param [String] partner_tag
    #   @param [String] partner_type
    #   @raise [Locale::NotFound] if marketplace is not found
    def initialize(marketplace: :us, **args)
      @locale = Locale.new(marketplace, **args)
      @client = HTTP::Client.new
    end

    # Returns details about specified browse nodes
    #
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
    #
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
    #
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
    #
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

    # Flags as persistent
    #
    # @param [Integer] timeout
    # @return [self]
    def persistent(timeout: 5)
      host = "https://#{locale.host}"
      @client = client.persistent(host, timeout: timeout)

      self
    end

    # @!method use(*features)
    #   Turn on {https://github.com/httprb/http HTTP} features
    #
    #   @param features
    #   @return [self]
    #
    # @!method via(*proxy)
    #   Make a request through an HTTP proxy
    #
    #   @param [Array] proxy
    #   @raise [HTTP::Request::Error] if HTTP proxy is invalid
    #   @return [self]
    %i[timeout via through headers use].each do |method_name|
      define_method(method_name) do |*args, &block|
        @client = client.send(method_name, *args, &block)
      end
    end

    private

    def validate(params)
      validate_keywords(params)
      validate_resources(params)
    end

    def validate_keywords(params)
      return unless params[:keywords]
      return if params[:keywords].is_a?(String)

      raise ArgumentError, ':keyword argument expects a String'
    end

    def validate_resources(params)
      return unless params[:resources]

      unless params[:resources].is_a?(Array)
        raise ArgumentError, ':resources argument expects an Array'
      end

      params[:resources].each do |resource|
        unless Resource.valid?(resource)
          raise ArgumentError, "There is not such resource: #{resource}"
        end
      end
    end

    def request(operation_name, params)
      validate(params)
      @operation = Operation.new(operation_name, params: params, locale: locale)
      response = client.headers(operation.headers)
                       .post(operation.url, body: operation.body)

      Response.new(response)
    end
  end
end
