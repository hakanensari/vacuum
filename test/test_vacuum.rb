require 'minitest/autorun'
require_relative '../lib/vacuum'

class TestVacuum < Minitest::Test
  include Vacuum

  def test_request_valid_locale
    assert_raises(Request::BadLocale) { Request.new('foo') }
  end

  def test_defaults_to_us_endpoint
    assert_equal 'http://webservices.amazon.com/onca/xml', Request.new.aws_endpoint
  end

  def test_returns_url
    req = Request.new
    req.configure(aws_access_key_id: 'key', aws_secret_access_key: 'secret', associate_tag: 'tag')
    assert_match(/webservices.amazon.com.*Foo=Bar/, req.url('Foo' => 'Bar'))
  end

  def test_fetches_parsable_response
    Excon.stub({}, { body: '<foo>bar</foo>' })
    req = Request.new
    req.configure(aws_access_key_id: 'key', aws_secret_access_key: 'secret', associate_tag: 'tag')
    res = req.item_lookup({}, mock: true)
    refute_empty res.to_h
    Excon.stubs.clear
  end
end
