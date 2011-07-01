module Sucker
  class Config
    class << self
      attr_accessor :key, :secret, :associate_tag, :locale
    end
  end
end
