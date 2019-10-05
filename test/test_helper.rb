# frozen_string_literal: true

require 'minitest/autorun'
require 'vcr'
require 'pry'
require_relative '../lib/vacuum'

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

def client
  Vacuum.new(
    access_key: 'AMAZON_KEY',
    secret_key: 'AMAZON_SECRET',
    partner_tag: 'test-20'
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
