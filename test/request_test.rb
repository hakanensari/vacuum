require 'minitest/autorun'
require_relative '../lib/vacuum'

module Vacuum
  describe Request do
    it 'requires a valid locale' do
      -> { Request.new('foo') }.must_raise Request::BadLocale
    end

    it 'requires an Associate Tag' do
      -> { Request.new('US').tag }.must_raise Request::MissingTag
    end

    it 'defaults to the US endpoint' do
      Request.new.endpoint.must_equal 'http://ecs.amazonaws.com/onca/xml'
    end
  end
end
