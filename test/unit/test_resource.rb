# frozen_string_literal: true

require 'helper'
require 'vacuum/resource'

module Vacuum
  class TestResource < Minitest::Test
    def test_all
      refute_empty Resource.all
    end
  end
end
