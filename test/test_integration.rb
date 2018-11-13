# frozen_string_literal: true

require 'minitest/autorun'
require 'vcr'
require_relative '../lib/vacuum'

ENV['AWS_ACCESS_KEY_ID'] ||= 'key'
ENV['AWS_SECRET_ACCESS_KEY'] ||= 'secret'

VCR.configure do |c|
  c.hook_into :excon
  c.cassette_library_dir = 'test/cassettes'
  c.default_cassette_options = {
    match_requests_on: [VCR.request_matchers.uri_without_param(
      'AWSAccessKeyId', 'AssociateTag', 'Signature', 'Timestamp', 'Version'
    )],
    record: :new_episodes
  }
end

class TestIntegration < Minitest::Test
  include Vacuum

  def setup
    VCR.insert_cassette('vacuum')
  end

  def teardown
    VCR.eject_cassette
  end

  def test_happy_path
    req = Vacuum.new
    req.associate_tag = 'foo'
    params = { 'SearchIndex' => 'All', 'Keywords' => 'vacuum' }
    res = req.item_search(query: params)
    assert res.dig('ItemSearchResponse', 'Items', 'Item')
  end

  def test_encoding_issues
    params = { 'SearchIndex' => 'All', 'Keywords' => 'google' }
    titles = locales.flat_map do |locale|
      req = Vacuum.new(locale)
      req.associate_tag = 'foo'
      res = req.item_search(query: params)
      items = res.dig('ItemSearchResponse', 'Items', 'Item') || []
      items.map { |item| item['ItemAttributes']['Title'] }
    end
    encodings = titles.map { |t| t.encoding.name }.uniq

    # Newer JRuby now appears to return both US-ASCII and UTF-8, depending on
    # whether the string has non-ASCII characters. MRI will only return latter.
    assert(encodings.any? { |encoding| encoding == 'UTF-8' })
  end

  def test_unauthorized_errors
    req = Vacuum.new
    req.associate_tag = 'foo'
    params = { 'SearchIndex' => 'All', 'Keywords' => 'amazon' }
    res = req.item_search(query: params)
    assert_equal 'InvalidClientTokenId', res.dig('ItemSearchErrorResponse', 'Error', 'Code')
  end

  private

  def locales
    Request::HOSTS.keys
  end
end
