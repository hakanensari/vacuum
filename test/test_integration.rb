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
end
