module AmazonProduct
  # An Amazon locale.
  class Locale
    # Available Amazon hosts.
    HOSTS = { :ca => 'ecs.amazonaws.ca',
              :cn => 'webservices.amazon.cn',
              :de => 'ecs.amazonaws.de',
              :fr => 'ecs.amazonaws.fr',
              :it => 'webservices.amazon.it',
              :jp => 'ecs.amazonaws.jp',
              :us => 'ecs.amazonaws.com',
              :uk => 'ecs.amazonaws.co.uk' }

    # The Amazon Web Services access key.
    attr_accessor :key

    # The Amazon Web Services secret.
    attr_accessor :secret

    # The Amazon associate tag.
    attr_accessor :tag

    def initialize(locale)
      raise BadLocale unless HOSTS.has_key?(locale)
      @locale = locale
    end

    # The Amazon host.
    def host
      HOSTS[@locale]
    end
  end
end
