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

  def test_defaults_to_latest_api_version
    assert_equal Request::LATEST_VERSION, @req.version
  end

  def test_accepts_uk_as_locale
    Request.new("UK")
  end

  def test_accepts_mx_as_locale
    Request.new("MX")
  end

  def test_fetches_parsable_response
    Excon.stub({}, body: '<foo/>')
    res = @req.item_lookup({}, mock: true)
    refute_empty res.parse
  end

  def test_alternative_query_syntax
    Excon.stub({}, body: '<foo/>')
    res = @req.item_lookup(query: {}, mock: true)
    refute_empty res.parse
  end

  def test_force_encodes_body
    res = Object.new
    def res.body
      ''.force_encoding('ASCII-8BIT')
    end
    assert_equal 'UTF-8', Response.new(res).body.encoding.name
  end

  def test_sets_custom_parser_on_class_level
    original_parser = Response.parser
    Excon.stub({}, body: '<foo/>')
    parser = MiniTest::Mock.new
    parser.expect(:parse, '123', ['<foo/>'])
    Response.parser = parser
    res = @req.item_lookup(query: {}, mock: true)
    assert_equal '123', res.parse
    Response.parser = original_parser # clean up
  end

  def test_sets_custom_parser_on_instance_level
    Excon.stub({}, body: '<foo/>')
    res = @req.item_lookup(query: {}, mock: true)
    parser = MiniTest::Mock.new
    parser.expect(:parse, '123', ['<foo/>'])
    res.parser = parser
    assert_equal '123', res.parse
  end

  def test_casts_to_hash
    Excon.stub({}, body: '<foo/>')
    parser = MiniTest::Mock.new
    res = @req.item_lookup(query: {}, mock: true)
    assert_kind_of Hash, res.to_h
    res.parser = parser
    assert_kind_of Hash, res.to_h
  end
end
