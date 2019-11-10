# frozen_string_literal: true

require 'aws-sigv4'
require 'http'
require 'json'

module Vacuum
  # An Amazon Product Advertising API operation
  class Operation
    # @!visibility private
    attr_reader :locale, :name, :params

    # Creates a new operation
    #
    # @param [String] name
    # @param [Hash] params
    # @param [Locale] locale
    def initialize(name, params:, locale:)
      @name = name
      @params = params
      @locale = locale
    end

    # @return [Hash]
    def headers
      signature.headers.merge(
        'x-amz-target' =>
          "com.amazon.paapi5.v1.ProductAdvertisingAPIv1.#{name}",
        'content-encoding' => 'amz-1.0',
        'content-type' => 'application/json; charset=utf-8'
      )
    end

    # @return [String]
    def body
      @body ||= build_body
    end

    # @return [String]
    def url
      @url ||= build_url
    end

    private

    def build_body
      hsh = { 'PartnerTag' => locale.partner_tag,
              'PartnerType' => locale.partner_type }

      params.each do |key, val|
        key = key.to_s.split('_')
                 .map { |word| word == 'asin' ? 'ASIN' : word.capitalize }.join
        hsh[key] = val
      end

      JSON.generate(hsh)
    end

    def build_url
      "https://#{locale.host}/paapi5/#{name.downcase}"
    end

    def signature
      signer.sign_request(http_method: 'POST', url: url, body: body)
    end

    def signer
      Aws::Sigv4::Signer.new(service: 'ProductAdvertisingAPI',
                             region: locale.region,
                             access_key_id: locale.access_key,
                             secret_access_key: locale.secret_key,
                             http_method: 'POST', endpoint: locale.host)
    end
  end
end
