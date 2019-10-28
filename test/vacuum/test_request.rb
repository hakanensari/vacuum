# frozen_string_literal: true

require 'integration_helper'

module Vacuum
  class RequestTest < IntegrationTest
    def test_get_browse_nodes
      requests.each do |request|
        response = request.get_browse_nodes(browse_node_ids: ['3045'])
        refute response.error?
      end
    end

    def test_get_items
      requests.each do |request|
        response = request.get_items(item_ids: ['B07212L4G2'])
        refute response.error?
      end
    end

    def test_get_items_with_options
      requests.each do |request|
        response = request.get_items(item_ids: 'B07212L4G2',
                                     resources: ['BrowseNodeInfo.BrowseNodes'])
        item = response.dig('ItemsResult', 'Items').first
        assert item.key?('BrowseNodeInfo')
      end
    end

    def test_get_variations
      requests.each do |request|
        response = request.get_variations(asin: 'B07212L4G2')
        refute response.error?
      end
    end

    def test_search_items
      requests.each do |request|
        response = request.search_items(keywords: 'Harry Potter')
        refute response.error?
      end
    end
  end
end
