# frozen_string_literal: true

module Vacuum
  class TestRequest < Minitest::Test
    def test_search_keywords
      err = assert_raises(ArgumentError) do
        api.search_items(keywords: ['Harry Potter'])
      end

      assert_equal ':keyword argument expects a String', err.message
    end

    def test_search_resources
      err = assert_raises(ArgumentError) do
        api.search_items(
          keywords: 'Harry Potter',
          resources: %w[Images.Primary.Large ItemInfo.ExternalIds Offer.Listings.Price]
        )
      end

      assert_equal 'There is not such resource: Offer.Listings.Price', err.message
    end

    def test_get_items_wrong_resource
      err = assert_raises(ArgumentError) do
        api.get_items(
          item_ids: :B07212L4G2,
          resources: %w[BrowseNodeInfo.BrowseNode.SalesRank]
        )
      end

      assert_equal 'There is not such resource: BrowseNodeInfo.BrowseNode.SalesRank', err.message
    end

    def test_get_variations_wrong_resource
      err = assert_raises(ArgumentError) do
        api.get_variations(asin: 'B07212L4G2', resources: %w[BrowseNodeInfo.BrowseNode.SalesRank])
      end

      assert_equal 'There is not such resource: BrowseNodeInfo.BrowseNode.SalesRank', err.message
    end

    def api
      @api ||= Vacuum.new(Locales.first)
    end
  end
end
