# frozen_string_literal: true

require 'minitest/autorun'
require 'vcr'
require_relative '../lib/vacuum'

AMAZON_KEY = 'AMAZON_KEY'
AMAZON_SECRET = 'AMAZON_SECRET'
AMAZON_TAG = 'test-20'

HTTPI.adapter = :excon

VCR.configure do |c|
  c.hook_into :excon
  c.cassette_library_dir = 'test/cassettes'
  c.default_cassette_options = {
    # match_requests_on: [VCR.request_matchers.uri_without_param(
    #  'AWSAccessKeyId', 'AssociateTag', 'Signature', 'Timestamp', 'Version'
    # )],
    record: :new_episodes
  }
end

class VacuumTest < Minitest::Test
  def setup
    VCR.insert_cassette('vacuum')
  end

  def teardown
    VCR.eject_cassette
  end

  DEFAULT_RESOURCES = [
    'BrowseNodeInfo.WebsiteSalesRank',
    'Images.Primary.Large',
    'ItemInfo.ByLineInfo',
    'ItemInfo.ContentInfo',
    'ItemInfo.ContentRating',
    'ItemInfo.Classifications',
    'ItemInfo.ExternalIds',
    'ItemInfo.Features',
    'ItemInfo.ManufactureInfo',
    'ItemInfo.ProductInfo',
    'ItemInfo.TechnicalInfo',
    'ItemInfo.Title',
    'ItemInfo.TradeInInfo',
    'Offers.Listings.Price',
    'ParentASIN'
  ].freeze

  def test_get_items
    response = client.get_items(
      item_ids: ['B07212L4G2'],
      resources: DEFAULT_RESOURCES
    )

    assert_equal 200, response.code
  end

  def test_get_variations
    response = client.get_variations(
      asin: 'B07212L4G2',
      resources: DEFAULT_RESOURCES
    )

    assert_equal 200, response.code
  end

  private

  def client
    Vacuum.new(
      access_key: AMAZON_KEY,
      secret_key: AMAZON_SECRET,
      partner_tag: AMAZON_TAG
    )
  end
end
