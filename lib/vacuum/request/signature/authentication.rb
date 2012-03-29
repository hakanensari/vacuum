module Vacuum
  module Request
    module Signature
      # Middleware that signs REST requests to various Amazon API endpoints with
      # an HMAC-SHA256 signature.
      class Authentication < Faraday::Middleware
        # Initializes the middleware.
        #
        # app - An Object that responds to `call` and returns a
        # Faraday::Response.
        # secret - The String Amazon AWS access secret key.
        def initialize(app, secret)
          @secret = secret
          super app
        end

        # Signs the request.
        #
        # env - A Hash that contains info about the request.
        #
        # Returns an Object that responds to `call` and returns a
        # Faraday::Response.
        def call(env)
          builder = Builder.new env, @secret
          builder.timestamp.sort_query.sign

          @app.call builder.env
        end
      end
    end
  end
end
