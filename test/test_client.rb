# frozen_string_literal: true

require "helper"
require "vacuum"

module Vacuum
  class TestClient < Minitest::Test
    def test_unknown_version
      assert_raises(ArgumentError) do
        Vacuum.new(credential_id: "id", credential_secret: "secret", version: "9.9")
      end
    end
  end
end
