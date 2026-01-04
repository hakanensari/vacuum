# frozen_string_literal: true

require "minitest/autorun"
require "vcr"

VCR.configure do |c|
  c.hook_into(:webmock)
  c.cassette_library_dir = "test/cassettes"
  c.default_cassette_options = { record: :new_episodes }
  c.filter_sensitive_data("PARTNER_TAG") { ENV.fetch("CREATORS_API_PARTNER_TAG", nil) }

  # Filter base64-encoded credentials
  credential_id = ENV.fetch("CREATORS_API_CREDENTIAL_ID", nil)
  credential_secret = ENV.fetch("CREATORS_API_CREDENTIAL_SECRET", nil)
  if credential_id && credential_secret
    encoded = ["#{credential_id}:#{credential_secret}"].pack("m0")
    c.filter_sensitive_data("BASIC_AUTH") { encoded }
  end
end
