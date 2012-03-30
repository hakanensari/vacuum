module Vacuum
  module Endpoint
    # An Amazon Web Services (AWS) API endpoint.
    class Base
      LOCALES = %w(CA CN DE ES FR IT JP UK US)

      # Raises a Not Implemented Error.
      #
      # When implemented, this should return a String AWS API host.
      def host
        raise NotImplementedError
      end

      # Returns the String AWS access key ID.
      #
      # Raises a Missing Key error if key is missing.
      def key
        @key or raise MissingKey
      end

      # Sets the String AWS access key ID.
      attr_writer :key

      # Returns the String AWS API locale (default: US).
      #
      # Raises a Bad Locale error if locale is not valid.
      def locale
        @locale ||= 'US'
        LOCALES.include? @locale or raise BadLocale

        @locale
      end

      # Sets the String AWS API locale.
      attr_writer :locale

      # Returns the String AWS access secret key.
      #
      # Raises a Missing Secret error if secret is missing.
      def secret
        @secret or raise MissingSecret
      end

      # Sets the String AWS access secret key.
      attr_writer :secret

      # Returns a String user agent for the AWS API request.
      def user_agent
        engine   = defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'
        language = [engine, RUBY_VERSION, "p#{RUBY_PATCHLEVEL}"].join ' '
        hostname = `hostname`.chomp
        version  = Vacuum::VERSION

        "Vacuum/#{version} (Language=#{language}; Host=#{hostname})"
      end
    end
  end
end
