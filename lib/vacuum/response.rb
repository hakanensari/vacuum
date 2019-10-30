# frozen_string_literal: true

require 'delegate'
require 'forwardable'
require 'json'

module Vacuum
  # A wrapper around the API response
  class Response < SimpleDelegator
    extend Forwardable

    def_delegator :to_h, :dig

    def to_h
      JSON.parse(body)
    end
  end
end
