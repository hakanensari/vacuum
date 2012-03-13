require 'forwardable'
require 'net/http'
require 'openssl'
require 'time'

require 'knack'
require 'nokogiri'

%w{request response}.each do |f|
  require "vacuum/#{f}"
end


# Vacuum is a Ruby wrapper to the Amazon Product Advertising API.
module Vacuum
  class BadLocale     < ArgumentError; end
  class MissingKey    < ArgumentError; end
  class MissingSecret < ArgumentError; end
  class MissingTag    < ArgumentError; end

  class << self
    extend Forwardable

    def_delegators Request, :new
  end
end
