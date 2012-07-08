module Vacuum
  module Request
    module Signature
      # Internal: Signs a request to an Amazon API with an HMAC-SHA256
      # signature.
      class Builder
        # Returns a Hash that contains info about the request.
        attr :env

        # Returns the String Amazon AWS access secret key.
        attr :secret

        # Initializes a new Builder.
        #
        # env - A Hash that contains info about the request.
        def initialize(env, secret)
          url = Addressable::URI.parse env[:url]
          if url.port.nil? and url.inferred_port
            # note: faraday/adapter/net_http.rb expects env[:url] to
            # be instance of URI or URI::HTTPS. URI::HTTPS#port would
            # return 443 but Addressable::URI#port would return nil.
            # Without this hack, net_http would try to connect to port
            # 80 for https request resulting in 'Connection Refuse'
            # error
            url.port = url.inferred_port
          end
          env[:url] = url
          @env, @secret = env, secret
        end

        # Returns the String name of the HTTP method used by the request.
        def method
          env[:method].to_s.upcase
        end

        # Signs the request.
        #
        # Returns self.
        def sign
          url.query = url.query.to_s + "&Signature=#{Utils.encode signature}"
          self
        end

        # Returns a String signature.
        def signature
          sha256 = OpenSSL::Digest::SHA256.new
          hash = OpenSSL::HMAC.digest sha256, secret, string_to_sign

          Base64.encode64(hash).chomp
        end

        # Sorts the URL query values of the request.
        #
        # Returns self.
        def sort_query
          url.query_values = url.query_values
          self
        end

        # Returns a String to sign based on pseudo-grammar specified by Amazon.
        def string_to_sign
          [method, url.host, url.path, url.query].join "\n"
        end

        # Timestamps the request.
        #
        # Returns self.
        def timestamp
          url.query = url.query.to_s + "&Timestamp=#{Utils.encode Time.now.utc.iso8601}"
          self
        end

        # Returns the Addressable::URI URL of the request.
        def url
          env[:url]
        end
      end
    end
  end
end
