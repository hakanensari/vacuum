# frozen_string_literal: true

require 'minitest/autorun'
require 'vcr'
require_relative '../lib/vacuum'

ACCESS_KEY = 'key'
SECRET_KEY = 'secret'
PARTNER_TAG = 'test-20'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'test/cassettes'
  c.default_cassette_options = {
    # match_requests_on: [VCR.request_matchers.uri_without_param(
    #  'AWSAccessKeyId', 'AssociateTag', 'Signature', 'Timestamp', 'Version'
    # )],
    record: :new_episodes
  }
  c.filter_sensitive_data('<KEY>') { ACCESS_KEY }
  c.filter_sensitive_data('<SECRET>') { SECRET_KEY }
  c.filter_sensitive_data('<PARTNER_TAG>') { PARTNER_TAG }
end

def client
  Vacuum.new(
    access_key: ACCESS_KEY,
    secret_key: SECRET_KEY,
    partner_tag: PARTNER_TAG
  )
end

RESOURCES = [
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
