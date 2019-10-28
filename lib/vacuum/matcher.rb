# frozen_string_literal: true

module Vacuum
  # Custom VCR matcher for stubbing calls to the Product Advertising API
  class Matcher
    IGNORED_KEYS = %w[PartnerTag].freeze

    attr_reader :requests

    def self.call(*requests)
      new(*requests).compare
    end

    def initialize(*requests)
      @requests = requests
    end

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
