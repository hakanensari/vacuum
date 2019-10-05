# frozen_string_literal: true

require_relative 'test_helper'

class VacuumTest < Minitest::Test
  def setup
    VCR.insert_cassette('vacuum')
  end

  def teardown
    VCR.eject_cassette
  end

  def test_get_items
    response = client.get_items(
      item_ids: ['B07212L4G2'],
      resources: RESOURCES
    )

    assert_equal 200, response.code
    assert_equal(['ItemsResult'], response.to_h.keys)
  end

  def test_get_variations
    response = client.get_variations(
      asin: 'B07212L4G2',
      resources: RESOURCES
    )

    assert_equal 200, response.code
    assert_equal(['VariationsResult'], response.to_h.keys)
  end
end
