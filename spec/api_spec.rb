# frozen_string_literal: true

require "helper"
require "vacuum"

describe Vacuum::Client do
  Credentials.each do |version, credentials|
    describe version do
      before do
        skip "No credentials for version #{version}" unless credentials

        VCR.insert_cassette(version)
      end

      after do
        VCR.eject_cassette if credentials
      end

      let(:credential_id) { credentials["credential_id"] }
      let(:credential_secret) { credentials["credential_secret"] }
      let(:marketplace) { credentials["marketplace"] }
      let(:partner_tag) { credentials["partner_tag"] }

      let(:client) { Vacuum.new(credential_id:, credential_secret:, version:) }

      it "gets browse nodes" do
        response = client.get_browse_nodes(marketplace:, partner_tag:, browse_node_ids: ["3045"])
        assert response.status.ok?, response.body.to_s
      end

      it "gets items" do
        response = client.get_items(marketplace:, partner_tag:, item_ids: ["B07212L4G2"])
        assert response.status.ok?, response.body.to_s
      end

      it "gets items with resources" do
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
        assert response.status.ok?, response.body.to_s
      end

      it "gets variations" do
        response = client.get_variations(marketplace:, partner_tag:, asin: "B07212L4G2")
        assert response.status.ok?, response.body.to_s
      end

      it "searches items" do
        response = client.search_items(marketplace:, partner_tag:, keywords: "Harry Potter")
        assert response.status.ok?, response.body.to_s
      end
    end
  end
end
