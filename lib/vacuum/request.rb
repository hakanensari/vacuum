# frozen_string_literal: true

require 'http'

require 'vacuum/locale'
require 'vacuum/operation'
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
      validate(params)
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
      validate(params)
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
      validate(params)
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

    ALL_RESOURCES = %w[
      BrowseNodeInfo.BrowseNodes BrowseNodeInfo.BrowseNodes.Ancestor
      BrowseNodeInfo.BrowseNodes.SalesRank BrowseNodeInfo.WebsiteSalesRank
      CustomerReviews.Count CustomerReviews.StarRating Images.Primary.Small
      Images.Primary.Medium Images.Primary.Large Images.Variants.Small
      Images.Variants.Medium Images.Variants.Large ItemInfo.ByLineInfo
      ItemInfo.ContentInfo ItemInfo.ContentRating ItemInfo.Classifications
      ItemInfo.ExternalIds ItemInfo.Features ItemInfo.ManufactureInfo
      ItemInfo.ProductInfo ItemInfo.TechnicalInfo ItemInfo.Title
      ItemInfo.TradeInInfo Offers.Listings.Availability.MaxOrderQuantity
      Offers.Listings.Availability.Message
      Offers.Listings.Availability.MinOrderQuantity
      Offers.Listings.Availability.Type Offers.Listings.Condition
      Offers.Listings.Condition.SubCondition
      Offers.Listings.DeliveryInfo.IsAmazonFulfilled
      Offers.Listings.DeliveryInfo.IsFreeShippingEligible
      Offers.Listings.DeliveryInfo.IsPrimeEligible
      Offers.Listings.DeliveryInfo.ShippingCharges
      Offers.Listings.IsBuyBoxWinner
      Offers.Listings.LoyaltyPoints.Points Offers.Listings.MerchantInfo
      Offers.Listings.Price Offers.Listings.ProgramEligibility.IsPrimeExclusive
      Offers.Listings.ProgramEligibility.IsPrimePantry
      Offers.Listings.Promotions Offers.Listings.SavingBasis
      Offers.Summaries.HighestPrice Offers.Summaries.LowestPrice
      Offers.Summaries.OfferCount ParentASIN
      RentalOffers.Listings.Availability.MaxOrderQuantity
      RentalOffers.Listings.Availability.Message
      RentalOffers.Listings.Availability.MinOrderQuantity
      RentalOffers.Listings.Availability.Type RentalOffers.Listings.BasePrice
      RentalOffers.Listings.Condition
      RentalOffers.Listings.Condition.SubCondition
      RentalOffers.Listings.DeliveryInfo.IsAmazonFulfilled
      RentalOffers.Listings.DeliveryInfo.IsFreeShippingEligible
      RentalOffers.Listings.DeliveryInfo.IsPrimeEligible
      RentalOffers.Listings.DeliveryInfo.ShippingCharges
      RentalOffers.Listings.MerchantInfo VariationSummary.Price.HighestPrice
      VariationSummary.Price.LowestPrice VariationSummary.VariationDimension
      SearchRefinements
    ].freeze

    def validate(params)
      if params[:keywords] && !params[:keywords].is_a?(String)
        raise ArgumentError, ':keyword argument expects a String'
      end

      if params[:resources]&.respond_to?(:each)
        params[:resources].each do |resource|
          unless ALL_RESOURCES.include?(resource)
            raise ArgumentError, "There is not such resource: #{resource}"
          end
        end
      end
    end

    def request(operation_name, params)
      @operation = Operation.new(operation_name, params: params, locale: locale)
      response = client.headers(operation.headers)
                       .post(operation.url, body: operation.body)

      Response.new(response)
    end
  end
end
