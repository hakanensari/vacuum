# frozen_string_literal: true

require 'helper'
require 'vacuum/request'

module Vacuum
  class TestRequest < Minitest::Test
    def test_search_keywords
      err = assert_raises(ArgumentError) do
        api.search_items(keywords: ['Harry Potter'])
      end

      assert_equal ':keyword argument expects a String', err.message
    end

    def api
      @api ||= Vacuum::Request.new(marketplace: 'US',
                                   access_key: 'key',
                                   secret_key: 'secret',
                                   partner_tag: 'tag')
    end
  end
end
