# frozen_string_literal: true

# Keep SimpleCov at top.
require 'simplecov'

SimpleCov.start do
  add_filter '/test/'
end

require 'minitest/autorun'
