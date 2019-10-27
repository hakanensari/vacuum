# frozen_string_literal: true

module Vacuum
  # A custom VCR matcher
  class Matcher
    IGNORED_KEYS = %w[PartnerTag].freeze

    attr_reader :requests

    def self.call(*requests)
      new(*requests).compare
    end

    # @api private
    def initialize(*requests)
      @requests = requests
    end

    # @api private
    def compare
      compare_uris && compare_bodies
    end

    private

    def compare_uris
      return false if hosts.reduce(:!=) || paths.reduce(:!=)
      return true if queries.all?(&:empty?)

      queries.reduce(:==)
    end

    def compare_bodies
      bodies.reduce(:==)
    end

    def uris
      requests.map { |r| URI.parse(r.uri) }
    end

    def hosts
      uris.map(&:host)
    end

    def paths
      uris.map(&:path)
    end

    def queries
      uris.map { |uri| extract_params(uri.query) }
    end

    def bodies
      if queries.all?(&:empty?)
        requests.map { |request| extract_params(request.body) }
      else
        requests.map(&:body)
      end
    end

    def extract_params(string)
      return {} unless string

      params = JSON.parse(string)
      IGNORED_KEYS.each { |k| params.delete(k) }

      params
    end
  end
end
