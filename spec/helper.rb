# frozen_string_literal: true

require "minitest/autorun"
require "vcr"

require_relative "credentials"

VCR.configure do |c|
  c.hook_into(:webmock)
  c.default_cassette_options = { record: :new_episodes }
  c.cassette_library_dir = "spec/cassettes"

  Credentials.filter_map { |_, c| c }.each do |credentials|
    encoded = ["#{credentials["credential_id"]}:#{credentials["credential_secret"]}"].pack("m0")
    c.filter_sensitive_data("BASIC_AUTH") { encoded }
    c.filter_sensitive_data("PARTNER_TAG") { credentials["partner_tag"] } if credentials["partner_tag"]
  end
end
