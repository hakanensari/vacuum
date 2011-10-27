module Vacuum
  # Raised when a bad locale is specified
  class BadLocale < ArgumentError; end

  # Raised when the Amazon key is not specified
  class MissingKey < ArgumentError; end

  # Raised when the Amazon secret is not specified
  class MissingSecret < ArgumentError; end

  # Raised when the Amazon associate tag is not specified
  class MissingTag < ArgumentError; end
end
