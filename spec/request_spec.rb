require 'minitest/autorun'
require_relative '../lib/vacuum'

module Vacuum
  describe Request do
    it 'requires a valid locale' do
      -> { Request.new('foo') }.must_raise Request::BadLocale
    end

    it 'defaults to the US endpoint' do
      Request.new.endpoint.must_equal 'http://ecs.amazonaws.com/onca/xml'
    end

    it 'returns a URL' do
      req = Request.new
      req.configure key: 'key', secret: 'secret', tag: 'tag'
      req.url('Foo' => 'Bar').must_match /amazonaws.com.*Foo=Bar/
    end
  end
end
