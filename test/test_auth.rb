# frozen_string_literal: true

require "helper"
require "vacuum/auth"

module Vacuum
  class TestAuth < Minitest::Test
    def test_url
      assert_equal(
        "https://creatorsapi.auth.us-west-2.amazoncognito.com/oauth2/token",
        Auth::URL,
      )
    end

    def test_initialize
      auth = Auth.new(credential_id: "id123", credential_secret: "secret123")

      assert_equal("id123", auth.credential_id)
      assert_equal("secret123", auth.credential_secret)
    end
  end
end
