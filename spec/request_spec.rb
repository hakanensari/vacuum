require 'minitest/autorun'
require_relative '../lib/vacuum'

module Vacuum
  describe Request do
    it 'requires a valid locale' do
      -> { Request.new('foo') }.must_raise Request::BadLocale
    end

    it 'defaults to the US endpoint' do
      Request.new.endpoint.must_equal 'http://webservices.amazon.com/onca/xml'
    end

    it 'returns a URL' do
      req = Request.new
      req.configure(aws_access_key: 'key', aws_secret_access_key: 'secret', tag: 'tag')
      req.url('Foo' => 'Bar').must_match /webservices.amazon.com.*Foo=Bar/
    end
  end
end
