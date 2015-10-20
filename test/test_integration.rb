require 'minitest/autorun'
require 'minitest/pride'
require 'vcr'
require_relative '../lib/vacuum'

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

  # rubocop:disable AbcSize
  def test_encoding_issues
    params = { 'SearchIndex' => 'All', 'Keywords' => 'google' }
    titles = %w(BR CA CN DE ES FR GB IN IT JP US MX).flat_map do |locale|
      req = Vacuum.new(locale)
      req.associate_tag = 'foo'
      res = req.item_search(query: params)
      items = res.to_h['ItemSearchResponse']['Items']['Item']
      items.map { |item| item['ItemAttributes']['Title'] }
    end
    encodings = titles.map { |t| t.encoding.name }.uniq

    # Newer JRuby now appears to return both US-ASCII and UTF-8, depending on
    # whether the string has non-ASCII characters. MRI will only return latter.
    assert encodings.any? { |encoding| encoding == 'UTF-8' }
  end
end
