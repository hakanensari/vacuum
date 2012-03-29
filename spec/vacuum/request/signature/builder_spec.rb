require 'spec_helper'

module Vacuum
  module Request
    module Signature
      describe Builder do
        let :url do
          Addressable::URI.parse 'http://example.com/foo?bar=1'
        end

        let :builder do
          described_class.new env, 'secret'
        end

        let :env do
          { :method => :get, :url => url }
        end

        describe '#method' do
          it 'returns an HTTP method' do
            builder.method.should eql 'GET'
          end
        end

        describe '#sign' do
          it 'signs the request' do
            builder.sign
            builder.url.query.should include 'Signature='
          end
        end

        describe '#signature' do
          after do
            builder.signature
          end

          it 'generates an HMAC-SHA signature' do
            OpenSSL::HMAC.should_receive(:digest).and_return 'secret'
          end

          it 'base64-encodes generated signature' do
            Base64.should_receive(:encode64).and_return 'a string'
          end
        end

        describe '#sort_query' do
          it 'sorts query values' do
            url.query = 'baz=0&bar=1'
            builder.sort_query
            builder.url.query.should eql 'bar=1&baz=0'
          end
        end

        describe '#string_to_sign' do
          it 'concatenates the request method, host, path, and query' do
            expected_string = %w(GET example.com /foo bar=1).join "\n"
            builder.string_to_sign.should eql expected_string
          end
        end

        describe '#timestamp' do
          it 'timestamps the request' do
            builder.timestamp
            builder.url.query.should include 'Timestamp='
          end
        end

        describe '#url' do
          it 'returns the request URL' do
            builder.url.should be_an Addressable::URI
          end
        end
      end
    end
  end
end
