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

    def test_get_browse_nodes
      response = client.get_browse_nodes(marketplace:, partner_tag:, browse_node_ids: ["3045"])
      assert(response.status.ok?)
    end

    def test_get_items
      response = client.get_items(marketplace:, partner_tag:, item_ids: ["B07212L4G2"])
      assert(response.status.ok?)
    end

    def test_get_items_with_resources
      resources = [
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
      ]

      response = client.get_items(marketplace:, partner_tag:, item_ids: "B07212L4G2", resources:)
      assert(response.status.ok?)
    end

    def test_get_variations
      response = client.get_variations(marketplace:, partner_tag:, asin: "B07212L4G2")
      assert(response.status.ok?)
    end

    def test_search_items
      response = client.search_items(marketplace:, partner_tag:, keywords: "Harry Potter")
      assert(response.status.ok?)
    end

    private

    def cassette_recorded?
      File.exist?(File.join(VCR.configuration.cassette_library_dir, "vacuum.yml"))
    end

    def credentials?
      ENV["CREATORS_API_CREDENTIAL_ID"] && ENV["CREATORS_API_CREDENTIAL_SECRET"]
    end

    def client
      @client ||= Vacuum.new(
        credential_id: ENV.fetch("CREATORS_API_CREDENTIAL_ID", "CREDENTIAL_ID"),
        credential_secret: ENV.fetch("CREATORS_API_CREDENTIAL_SECRET", "CREDENTIAL_SECRET"),
        version: ENV.fetch("CREATORS_API_VERSION", "2.1"),
      )
    end

    def marketplace
      ENV.fetch("CREATORS_API_MARKETPLACE", "www.amazon.com")
    end

    def partner_tag
      ENV.fetch("CREATORS_API_PARTNER_TAG", "PARTNER_TAG")
    end
  end
end
