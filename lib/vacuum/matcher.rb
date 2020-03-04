# frozen_string_literal: true

require 'json'

module Vacuum
  # Custom VCR matcher for stubbing calls to the Product Advertising API
  #
  # The matcher is not required by default.
  #
  # @example
  #    require 'vacuum/matcher'
  #
  #    # in your test
  #    VCR.insert_cassette('cassette_name',
  #                        match_requests_on: [Vacuum::Matcher])
  #
  # @see https://relishapp.com/vcr/vcr/v/5-0-0/docs/request-matching/register-and-use-a-custom-matcher
  class Matcher
    IGNORED_KEYS = %w[PartnerTag].freeze
    private_constant :IGNORED_KEYS

    # @!visibility private
    attr_reader :requests

    # @!visibility private
    def self.call(*requests)
      new(*requests).compare
    end

    # @!visibility private
    def initialize(*requests)
      @requests = requests
    end

    # @!visibility private
    def compare
      uris.reduce(:==) && bodies.reduce(:==)
    end

    private

    def uris
      requests.map(&:uri)
    end

    def bodies
      requests.map do |req|
        params = JSON.parse(req.body)
        IGNORED_KEYS.each { |k| params.delete(k) }

        params
      end
    end
  end
end

if defined?(RSpec)
  RSpec.configure do |config|
    config.around do |example|
      if example.metadata[:paapi]
        metadata = example.metadata[:paapi]
        metadata = {} if metadata == true
        example.metadata[:vcr] = metadata.merge(
          match_requests_on: [Vacuum::Matcher]
        )
      end

      example.run
    end
  end
end
