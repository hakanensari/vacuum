# frozen_string_literal: true

require 'integration_helper'

module Vacuum
  class TestRequests < IntegrationTest
    def test_get_browse_nodes
      requests.each do |request|
        response = request.get_browse_nodes(browse_node_ids: ['3045'])
        assert_equal 200, response.status
      end
    end

    def test_get_items
      requests.each do |request|
        response = request.get_items(item_ids: ['B07212L4G2'])
        assert_equal 200, response.status
      end
    end

    RESOURCE_ALL = %w[BrowseNodeInfo.BrowseNodes
                      BrowseNodeInfo.BrowseNodes.Ancestor
                      BrowseNodeInfo.BrowseNodes.SalesRank
                      BrowseNodeInfo.WebsiteSalesRank
                      Images.Primary.Small
                      Images.Primary.Medium
                      Images.Primary.Large
                      Images.Variants.Small
                      Images.Variants.Medium
                      Images.Variants.Large
                      ItemInfo.ByLineInfo
                      ItemInfo.Classifications
                      ItemInfo.ContentInfo
                      ItemInfo.ContentRating
                      ItemInfo.ExternalIds
                      ItemInfo.Features
                      ItemInfo.ManufactureInfo
                      ItemInfo.ProductInfo
                      ItemInfo.TechnicalInfo
                      ItemInfo.Title
                      ItemInfo.TradeInInfo
                      Offers.Listings.Availability.MaxOrderQuantity
                      Offers.Listings.Availability.Message
                      Offers.Listings.Availability.MinOrderQuantity
                      Offers.Listings.Availability.Type
                      Offers.Listings.Condition
                      Offers.Listings.Condition.SubCondition
                      Offers.Listings.DeliveryInfo.IsAmazonFulfilled
                      Offers.Listings.DeliveryInfo.IsFreeShippingEligible
                      Offers.Listings.DeliveryInfo.IsPrimeEligible
                      Offers.Listings.IsBuyBoxWinner
                      Offers.Listings.LoyaltyPoints.Points
                      Offers.Listings.MerchantInfo
                      Offers.Listings.Price
                      Offers.Listings.ProgramEligibility.IsPrimeExclusive
                      Offers.Listings.ProgramEligibility.IsPrimePantry
                      Offers.Listings.Promotions
                      Offers.Listings.SavingBasis
                      Offers.Summaries.HighestPrice
                      Offers.Summaries.LowestPrice
                      Offers.Summaries.OfferCount
                      ParentASIN].freeze

    def test_get_items_with_all_resources
      requests.each do |request|
        response = request.get_items(item_ids: 'B07212L4G2',
                                     resources: RESOURCE_ALL)
        assert_equal 200, response.status
        item = response.dig('ItemsResult', 'Items').first
        assert item.key?('BrowseNodeInfo')
      end
    end

    def test_get_variations
      requests.each do |request|
        response = request.get_variations(asin: 'B07212L4G2')
        assert_equal 200, response.status
      end
    end

    def test_search_items
      requests.each do |request|
        response = request.search_items(keywords: 'Harry Potter')
        assert_equal 200, response.status
      end
    end

    def test_persistent
      request = requests.sample
      refute_predicate request.client, :persistent?
      request.persistent
      assert_predicate request.client, :persistent?
    end

    def test_logging
      require 'logger'
      logdev = StringIO.new
      logger = Logger.new(logdev)
      request = requests.sample
      request.use(logging: { logger: logger })
      request.search_items(keywords: 'Harry Potter')
      refute_empty logdev.string
    end
  end
end
