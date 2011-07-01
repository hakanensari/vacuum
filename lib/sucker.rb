require 'sucker/config'
require 'sucker/request'
require 'sucker/response'

# = Sucker
#
# Sucker is a Ruby wrapper to the Amazon Product Advertising API.
module Sucker

  class << self

    # Creates a request object for a specified Amazon locale.
    #
    #   request = Sucker.new(:us)
    #
    def new(args = :us)
      if args.is_a?(Hash)
        Kernel.warn "[DEPRECATION] Configure request using `Sucker.configure`."

        locale = args.delete(:locale)
        configure(locale) do |c|
          args.each { |k, v| c.send("#{k}=", v) }
        end
      else
        locale = args
      end

      Request.new(config(locale))
    end

    # The config for specified locale.
    #
    # It defaults to the US if no locale is specified.
    def config(locale = :us)
      locale = locale.to_sym
      configs[locale] ||= Config.new(locale)
    end

    # Configures an Amazon locale.
    #
    #   Sucker.configure(:us) do |c|
    #     c.key           = api_key
    #     c.secret        = api_secret
    #     c.associate_tag = associate_tag
    #   end
    #
    # If no locale is specified, it defaults to the US.
    def configure(locale = :us, &block)
      yield config(locale)
    end

    private

    def configs
      @configs ||= Hash.new
    end
  end
end
