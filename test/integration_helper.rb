# frozen_string_literal: true

require 'minitest/autorun'
require 'vcr'

require 'locales'
require 'vacuum'
require 'vacuum/matcher'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'test/cassettes'
  c.default_cassette_options = {
    match_requests_on: [Vacuum::Matcher],
    record: ENV['RECORD'] ? :new_episodes : :none
  }
  c.before_record do |interaction|
    interaction.ignore! if interaction.response.status.code != 200
  end

  Locales.each do |record|
    record.each do |key, val|
      next if key == :marketplace

      c.filter_sensitive_data(key.upcase) { val }
    end
  end
end

HTTPI.log = false

module Vacuum
  class IntegrationTest < Minitest::Test
    def setup
      if ENV['LIVE']
        VCR.turn_off!
        WebMock.allow_net_connect!
      else
        VCR.insert_cassette('vacuum')
      end
    end

    def teardown
      VCR.eject_cassette if VCR.turned_on?
    end

    private

    def requests
      Locales.map { |credentials| Vacuum.new(credentials) }.shuffle
    end
  end
end
