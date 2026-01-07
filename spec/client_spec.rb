# frozen_string_literal: true

require "helper"
require "vacuum"

describe Vacuum::Client do
  it "raises on unknown version" do
    assert_raises(ArgumentError) do
      Vacuum.new(credential_id: "id", credential_secret: "secret", version: "9.9")
    end
  end
end
