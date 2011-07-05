module Sucker
  # Amazon credentials.
  module Config
    extend self

    # The Amazon locale.
    attr_accessor :locale

    # The Amazon Web Services access key.
    attr_accessor :key

    # The Amazon Web Services secret.
    attr_accessor :secret

    # The Amazon associate tag.
    attr_accessor :associate_tag

    def configure
      yield self
    end
  end
end
