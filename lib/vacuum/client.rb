# frozen_string_literal: true

require "http"

module Vacuum
  # A client for the Amazon Creators API
  #
  # Handles authentication automatically and caches access tokens.
  #
  # @example Basic usage
  #   client = Vacuum::Client.new(
  #     credential_id: "YOUR_CREDENTIAL_ID",
  #     credential_secret: "YOUR_CREDENTIAL_SECRET",
  #     version: "2.1"
  #   )
  #   response = client.search_items(
  #     marketplace: "www.amazon.com",
  #     partner_tag: "yourtag-20",
  #     keywords: "ruby programming"
  #   )
  #
  # @example With shared cache (for multi-process environments like Rails)
  #   client = Vacuum::Client.new(
  #     credential_id: "YOUR_CREDENTIAL_ID",
  #     credential_secret: "YOUR_CREDENTIAL_SECRET",
  #     version: "2.1",
  #     cache: Rails.cache
  #   )
  class Client
    AUTH_URLS = {
      "2.1" => "https://creatorsapi.auth.us-east-1.amazoncognito.com/oauth2/token",
      "2.2" => "https://creatorsapi.auth.eu-south-2.amazoncognito.com/oauth2/token",
      "2.3" => "https://creatorsapi.auth.us-west-2.amazoncognito.com/oauth2/token",
    }.freeze

    API_URL = "https://creatorsapi.amazon/catalog/v1"

    TOKEN_TTL = 3570 # 59.5 minutes (tokens valid for 1 hour)

    # Creates a new client
    #
    # @param credential_id [String] Your Creators API credential ID
    # @param credential_secret [String] Your Creators API credential secret
    # @param version [String] API version ("2.1", "2.2", or "2.3")
    # @param cache [#fetch] Optional cache store (e.g., Rails.cache)
    # @param http [HTTP::Client] HTTP client (for testing)
    def initialize(version:, credential_id:, credential_secret:, cache: nil, http: HTTP)
      @version = version
      @auth_url = AUTH_URLS.fetch(version) do
        raise ArgumentError, "Unknown version: #{version}"
      end
      @credential_id = credential_id
      @credential_secret = credential_secret
      @cache = cache
      @http = http
    end

    # Returns details about specified browse nodes
    #
    # @param marketplace [String] The marketplace (e.g., "www.amazon.com")
    # @param partner_tag [String] Your partner/tracking tag
    # @param browse_node_ids [Array<String>] The browse node IDs to look up
    # @return [HTTP::Response]
    def get_browse_nodes(marketplace:, partner_tag:, browse_node_ids:, **params)
      params[:browse_node_ids] = Array(browse_node_ids)
      request("getBrowseNodes", marketplace:, partner_tag:, **params)
    end

    # Returns the attributes of one or more items
    #
    # @param marketplace [String] The marketplace (e.g., "www.amazon.com")
    # @param partner_tag [String] Your partner/tracking tag
    # @param item_ids [Array<String>, String] The item IDs (ASINs) to look up
    # @return [HTTP::Response]
    def get_items(marketplace:, partner_tag:, item_ids:, **params)
      params[:item_ids] = Array(item_ids)
      request("getItems", marketplace:, partner_tag:, **params)
    end

    # Returns variations of a product
    #
    # @param marketplace [String] The marketplace (e.g., "www.amazon.com")
    # @param partner_tag [String] Your partner/tracking tag
    # @param asin [String] The ASIN to get variations for
    # @return [HTTP::Response]
    def get_variations(marketplace:, partner_tag:, **params)
      request("getVariations", marketplace:, partner_tag:, **params)
    end

    # Searches for items on Amazon
    #
    # @param marketplace [String] The marketplace (e.g., "www.amazon.com")
    # @param partner_tag [String] Your partner/tracking tag
    # @param keywords [String] Search keywords
    # @return [HTTP::Response]
    def search_items(marketplace:, partner_tag:, **params)
      request("searchItems", marketplace:, partner_tag:, **params)
    end

    private

    def request(operation, marketplace:, partner_tag:, **params)
      @http
        .headers(
          "Authorization" => "Bearer #{access_token}, Version #{@version}",
          "x-marketplace" => marketplace,
        )
        .post("#{API_URL}/#{operation}", json: camelize_keys(marketplace:, partner_tag:, **params))
    end

    def camelize_keys(**params)
      params.transform_keys { |key| key.to_s.gsub(/_([a-z])/) { ::Regexp.last_match(1).upcase } }
    end

    def access_token
      if @cache
        @cache.fetch(cache_key, expires_in: TOKEN_TTL) { fetch_token }
      else
        @access_token = fetch_token if token_expired?
        @access_token
      end
    end

    def cache_key
      "vacuum/#{@credential_id}/token"
    end

    def token_expired?
      @access_token.nil? || @token_expires_at.nil? || Time.now >= @token_expires_at
    end

    def fetch_token
      response = @http
        .basic_auth(user: @credential_id, pass: @credential_secret)
        .post(@auth_url, form: {
          grant_type: "client_credentials",
          scope: "creatorsapi/default",
        })

      data = response.parse
      @token_expires_at = Time.now + TOKEN_TTL
      @access_token = data["access_token"]
    end
  end
end
