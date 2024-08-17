# frozen_string_literal: true

require 'helper'
require 'vacuum/locale'
require 'vacuum/operation'

module Vacuum
  class TestOperation < Minitest::Test
    def setup
      @operation = Operation.new('Action', params: { foo: 1 }, locale:)
    end

    def test_body
      assert @operation.body
    end

    def test_url
      assert @operation.url
    end

    def test_headers
      assert @operation.headers
    end

    private

    def locale
      Locale.new(:us, access_key: '123', secret_key: '123', partner_tag: 'xyz')
    end
  end
end
