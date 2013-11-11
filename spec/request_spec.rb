require 'minitest/autorun'
require_relative '../lib/vacuum'

module Vacuum
  describe Request do
    it 'requires a valid locale' do
      -> { Request.new('foo') }.must_raise Request::BadLocale
    end

    it 'defaults to the US endpoint' do
      Request.new.aws_endpoint.must_equal 'http://webservices.amazon.com/onca/xml'
    end

    it 'returns a URL' do
      req = Request.new
      req.configure(aws_access_key_id: 'key', aws_secret_access_key: 'secret', associate_tag: 'tag')
      req.url('Foo' => 'Bar').must_match(/webservices.amazon.com.*Foo=Bar/)
    end

    it 'fetches a parsable response' do
      Excon.stub({}, { body: '<foo>bar</foo>' })
      req = Request.new
      req.configure(aws_access_key_id: 'key', aws_secret_access_key: 'secret', associate_tag: 'tag')
      res = req.item_lookup({}, mock: true)
      res.to_h.wont_be_empty
      Excon.stubs.clear
    end
  end
end
