# frozen_string_literal: true

require "minitest/autorun"
require "minitest/mock"
require "vcr"

VCR.configure do |c|
  c.hook_into(:webmock)
  c.cassette_library_dir = "test/cassettes"
  c.filter_sensitive_data("ACCESS_TOKEN") { ENV.fetch("CREATORS_API_ACCESS_TOKEN", nil) }
  c.filter_sensitive_data("PARTNER_TAG") { ENV.fetch("CREATORS_API_PARTNER_TAG", nil) }
end
