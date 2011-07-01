module Sucker
  class Config
    HOSTS = {
      :us  => 'ecs.amazonaws.com',
      :uk  => 'ecs.amazonaws.co.uk',
      :de  => 'ecs.amazonaws.de',
      :ca  => 'ecs.amazonaws.ca',
      :fr  => 'ecs.amazonaws.fr',
      :jp  => 'ecs.amazonaws.jp' }
    LOCALES = HOSTS.keys

    # The Amazon locale.
    attr_reader :locale

    # The Amazon Web Services access key.
    attr_accessor :key

    # The Amazon Web Services secret.
    attr_accessor :secret

    # The Amazon associate tag.
    attr_accessor :associate_tag

    # Creates a config for a locale.
    def initialize(locale)
      @locale = locale
    end

    # The Amazon host.
    def host
      HOSTS[locale]
    end
  end
end
