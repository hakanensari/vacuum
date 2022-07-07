# frozen_string_literal: true

require 'helper'
require 'vacuum/response'

module Vacuum
  class TestResponse < Minitest::Test
    def setup
      mock = Minitest::Mock.new
      mock.expect(:body, %({"ItemsResult":{"Items":[{"ASIN":"B07212L4G2"}]}}))
      @response = Response.new(mock)
    end

    def test_parse
      assert @response.parse
    end

    def test_cast_to_hash
      assert_kind_of Hash, @response.to_h
    end

    def test_dig
      assert @response.dig('ItemsResult', 'Items')
    end

    def test_parser
      @response.parser = Class.new
      @response.parser.define_singleton_method(:parse) { |_| 'foo' }

      refute_empty @response.parse
    end
  end
end
