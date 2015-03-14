require 'minitest/autorun'
require 'minitest/pride'
require 'vcr'
require_relative '../lib/vacuum'

VCR.configure do |c|
  c.hook_into :excon
  c.cassette_library_dir = 'test/cassettes'
  c.default_cassette_options = {
    match_requests_on: [VCR.request_matchers.uri_without_param(
      'AWSAccessKeyId', 'AssociateTag', 'Signature', 'Timestamp'
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

  def test_encoding_issues
    params = { 'SearchIndex' => 'All', 'Keywords' => 'google' }

    %w(BR CA CN DE ES FR GB IN IT JP US).each do |locale|
      req = Vacuum.new(locale)
      req.associate_tag = 'foo'
      res = req.item_search(query: params)
      item = res.to_h['ItemSearchResponse']['Items']['Item'].sample

      assert_equal 'UTF-8', item['ASIN'].encoding.name
    end
  end
end
