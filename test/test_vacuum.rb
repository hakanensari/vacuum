require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/vacuum'

class TestVacuum < Minitest::Test
  include Vacuum

  def setup
    @req = Request.new
  end

  def teardown
    Excon.stubs.clear
  end

  def test_requires_valid_locale
    assert_raises(Request::BadLocale) { Request.new('foo') }
  end

  def test_defaults_to_us_endpoint
    assert_equal 'http://webservices.amazon.com/onca/xml', @req.aws_endpoint
  end

  def test_fetches_parsable_response
    Excon.stub({}, { body: '<foo>bar</foo>' })
    @req.configure(aws_access_key_id: 'key', aws_secret_access_key: 'secret', associate_tag: 'tag')
    res = @req.item_lookup({}, mock: true)
    refute_empty res.to_h
  end

  def test_alternative_query_syntax
    Excon.stub({}, { body: '<foo>bar</foo>' })
    req = Request.new
    req.configure(aws_access_key_id: 'key', aws_secret_access_key: 'secret', associate_tag: 'tag')
    res = req.item_lookup(query: {}, mock: true)
    refute_empty res.to_h
  end

  def test_force_encodes_body
    res = Object.new
    def res.body; String.new.force_encoding('ASCII-8BIT'); end
    assert_equal 'UTF-8', Response.new(res).body.encoding.name
  end
end
