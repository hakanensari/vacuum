require 'spec_helper'

module Vacuum
  module Request
    module Signature
      describe Authentication do
        let(:middleware) do
          described_class.new lambda { |env| env }, 'secret'
        end

        def result
          env = { :url => 'http:://example.com/foo?Baz=2&Bar=1' }
          middleware.call env
        end

        it 'sorts the query values' do
          result[:url].query.should match /^Bar/
        end

        it 'timestamps the request' do
          result[:url].query.should include 'Timestamp'
        end

        it 'signs the request' do
          result[:url].query.should include 'Signature'
        end
      end
    end
  end
end
