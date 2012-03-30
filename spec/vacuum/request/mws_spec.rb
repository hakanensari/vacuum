require 'spec_helper'

module Vacuum
  module Request
    describe MWS do
      let(:request) do
        described_class.new do |config|
          config.key = 'key'
          config.marketplace = 'marketplace'
          config.secret = 'secret'
          config.seller = 'seller'
        end
      end

      context 'when API type is set to Products' do
        before do
          request.configure do |config|
            config.api_type = :products
          end
        end

        it_behaves_like 'a request'
      end
    end
  end
end
