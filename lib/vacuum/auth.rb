# frozen_string_literal: true

require "http"

module Vacuum
  # Requests OAuth 2.0 access tokens for the Amazon Creators API
  #
  # Uses the client_credentials grant type to obtain tokens for API access.
  # Tokens are valid for 1 hour (3600 seconds).
  #
  # @example Request a token
  #   response = Vacuum::Auth.request(
  #     credential_id: "YOUR_CREDENTIAL_ID",
  #     credential_secret: "YOUR_CREDENTIAL_SECRET"
  #   )
  #   access_token = response.to_h["access_token"]
  class Auth
    URL = "https://creatorsapi.auth.us-west-2.amazoncognito.com/oauth2/token"

    attr_reader :credential_id, :credential_secret

    class << self
      def request(...)
        new(...).request
      end
    end

    def initialize(credential_id:, credential_secret:)
      @credential_id = credential_id
      @credential_secret = credential_secret
    end

    def request
      HTTP.basic_auth(user: credential_id, pass: credential_secret)
        .post(URL, form: {
          grant_type: "client_credentials",
          scope: "creatorsapi/default",
        })
    end
  end
end
