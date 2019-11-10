# frozen_string_literal: true

require 'minitest/autorun'
require 'vacuum/locale'

module Vacuum
  class TestLocale < Minitest::Test
    def test_host
      locale = Locale.new(:us, credentials)
      assert locale.host
    end

    def test_region
      locale = Locale.new(:us, credentials)
      assert locale.region
    end

    def test_partner_type_default
      locale = Locale.new(:us, credentials)
      assert locale.partner_type
    end

    def test_upcased_marketplace
      Locale.new('US', credentials) # does not raise
    end

    def test_uk
      Locale.new(:uk, credentials) # does not raise
    end

    def test_not_found
      assert_raises Locale::NotFound do
        Locale.new(:foo, credentials)
      end
    end

    private

    def credentials
      { access_key: '123', secret_key: '123', partner_tag: 'xyz-20' }
    end
  end
end
