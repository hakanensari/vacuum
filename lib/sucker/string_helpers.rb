require 'active_support/core_ext/string/inflections'

module Sucker
  module StringHelpers #:nodoc: all
    def camelize(key)
      key.is_a?(Symbol) ? key.to_s.camelize : key
    end

    def escape(value)
      value.gsub(/([^a-zA-Z0-9_.~-]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end
    end

    def stringify(value)
      value.is_a?(Array) ? value.join(',') : value.to_s
    end
  end
end
