# frozen_string_literal: true

require "helper"
require "vacuum"

module Vacuum
  class TestAPI < Minitest::Test
    def setup
      skip("No cassette recorded") unless cassette_recorded? || credentials?

      VCR.insert_cassette("vacuum")
    end

    def teardown
      VCR.eject_cassette
    end

    def cassette_recorded?
      File.exist?(File.join(VCR.configuration.cassette_library_dir, "vacuum.yml"))
    end

    def credentials?
      ENV.fetch("CREATORS_API_ACCESS_TOKEN", nil) && ENV.fetch("CREATORS_API_PARTNER_TAG", nil)
    end

    def test_get_browse_nodes
      response = request.get_browse_nodes(browse_node_ids: ["3045"])

      assert_equal(200, response.status)
    end

    def test_get_items
      response = request.get_items(item_ids: ["B07212L4G2"])

      assert_equal(200, response.status)
    end

    # Creators API resource names (lowerCamelCase)
    RESOURCE_ALL = [
      "browseNodeInfo.browseNodes",
      "browseNodeInfo.browseNodes.ancestor",
      "browseNodeInfo.browseNodes.salesRank",
      "browseNodeInfo.websiteSalesRank",
      "images.primary.small",
      "images.primary.medium",
      "images.primary.large",
      "images.variants.small",
      "images.variants.medium",
      "images.variants.large",
      "itemInfo.byLineInfo",
      "itemInfo.classifications",
      "itemInfo.contentInfo",
      "itemInfo.contentRating",
      "itemInfo.externalIds",
      "itemInfo.features",
      "itemInfo.manufactureInfo",
      "itemInfo.productInfo",
      "itemInfo.technicalInfo",
      "itemInfo.title",
      "itemInfo.tradeInInfo",
      "offersV2.listings.availability",
      "offersV2.listings.condition",
      "offersV2.listings.dealDetails",
      "offersV2.listings.isBuyBoxWinner",
      "offersV2.listings.loyaltyPoints",
      "offersV2.listings.merchantInfo",
      "offersV2.listings.price",
      "offersV2.listings.type",
      "parentASIN",
    ].freeze

    def test_get_items_with_all_resources
      response = request.get_items(
        item_ids: "B07212L4G2",
        resources: RESOURCE_ALL,
      )

      assert_equal(200, response.status)
      item = response.dig("itemResults", "items")&.first

      assert(item&.key?("browseNodeInfo"))
    end

    def test_get_variations
      response = request.get_variations(asin: "B07212L4G2")

      assert_equal(200, response.status)
    end

    def test_search_items
      response = request.search_items(keywords: "Harry Potter")

      assert_equal(200, response.status)
    end

    private

    def request
      @request ||= Vacuum.new(
        marketplace: "www.amazon.com",
        access_token: ENV.fetch("CREATORS_API_ACCESS_TOKEN", "ACCESS_TOKEN"),
        version: "2.1",
        partner_tag: ENV.fetch("CREATORS_API_PARTNER_TAG", "PARTNER_TAG"),
      )
    end
  end
end
