# frozen_string_literal: true

require_relative 'test_helper'

class VacuumTest < Minitest::Test
  def setup
    VCR.insert_cassette('vacuum')
  end

  def teardown
    VCR.eject_cassette
  end

  def test_set_resource_once
    client = Vacuum.new(
      access_key: 'AMAZON_KEY',
      secret_key: 'AMAZON_SECRET',
      partner_tag: 'test-20',
      resources: RESOURCES
    )

    response = client.get_items(item_ids: ['B07212L4G2'])
    assert_equal '200', response.code
    response = client.get_variations(asin: 'B07212L4G2')
    assert_equal '200', response.code
  end

  def test_get_browse_nodes
    response = client.get_browse_nodes(
      browse_node_ids: ['3045']
    )

    assert_equal '200', response.code
    assert_equal(['BrowseNodesResult'], response.to_h.keys)
  end

  def test_get_items
    response = client.get_items(
      item_ids: ['B07212L4G2'],
      resources: RESOURCES
    )

    assert_equal '200', response.code
    assert_equal(['ItemsResult'], response.to_h.keys)
  end

  def test_get_items_with_options
    response = client.get_items(
      item_ids: ['B07212L4G2'],
      resources: ['BrowseNodeInfo.WebsiteSalesRank'],
      languages_of_preference: 'fr_CA',
      offer_count: '10'
    )

    assert_equal '200', response.code
    assert_equal(['ItemsResult'], response.to_h.keys)
  end

  def test_get_variations
    response = client.get_variations(
      asin: 'B07212L4G2',
      resources: RESOURCES
    )

    assert_equal '200', response.code
    assert_equal(['VariationsResult'], response.to_h.keys)
  end
end
