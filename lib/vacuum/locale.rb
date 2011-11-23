module Vacuum
  # An Amazon Web Services locale
  class Locale
    # Amazon hosts
    HOSTS = { :ca => 'ecs.amazonaws.ca',
              :cn => 'webservices.amazon.cn',
              :de => 'ecs.amazonaws.de',
              :es => 'webservices.amazon.es',
              :fr => 'ecs.amazonaws.fr',
              :it => 'webservices.amazon.it',
              :jp => 'ecs.amazonaws.jp',
              :uk => 'ecs.amazonaws.co.uk',
              :us => 'ecs.amazonaws.com' }

    # Country codes
    LOCALES = HOSTS.keys

    # @return [String] the access key
    attr_accessor :key

    # @return [String] the secret
    attr_accessor :secret

    # @return [String] the associate tag
    attr_accessor :tag

    # @param [Symbol] locale the country code
    # @raise [Vacuum::BadLocale] locale is bad
    def initialize(locale)
      unless LOCALES.include? locale
        raise BadLocale, <<-MSG.strip
          Valid values are #{LOCALES.join(', ')}
        MSG
      end

      @locale = locale
    end

    # @yield passes locale to given block for configuration
    # @raise [Vacuum::MissingKey] Amazon key is missing
    # @raise [Vacuum::MissingSecret] Amazon secret is missing
    # @raise [Vacuum::MissingTag] Amazon associate tag is missing
    def configure(&blk)
      yield self

      raise MissingKey    unless key
      raise MissingSecret unless secret
      raise MissingTag    unless tag

      self.freeze
    end

    # @return [String] the host
    def host
      HOSTS[@locale]
    end
  end
end
