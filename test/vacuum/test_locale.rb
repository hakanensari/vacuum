# frozen_string_literal: true

require 'minitest/autorun'
require 'vacuum/locale'

module Vacuum
  class TestLocale < Minitest::Test
    def test_find
      assert_kind_of Locale, Locale.find('US')
    end

    def test_find_lowercase_sym
      assert_kind_of Locale, Locale.find(:us)
    end

    def test_find_uk
      assert_equal Locale.find('GB'), Locale.find('UK')
    end

    def test_raise_if_not_found
      assert_raises Locale::NotFound do
        Locale.find('foo')
      end
    end

    def test_build_url
      assert_equal 'https://webservices.amazon.com/paapi5/foo',
                   Locale.find('US').build_url('Foo')
    end

    def test_marketplace
      assert_equal 'www.amazon.com', Locale.find('US').marketplace
    end
  end
end
