# frozen_string_literal: true

require 'forwardable'

require 'vacuum/request'
require 'vacuum/version'

# Ruby wrapper to the Amazon Product Advertising API
module Vacuum
  class << self
    extend Forwardable

    def_delegator 'Vacuum::Request', :new
  end
end
