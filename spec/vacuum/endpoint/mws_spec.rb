require 'spec_helper'

module Vacuum
  module Endpoint
    describe MWS do
      let(:endpoint) do
        described_class.new
      end

      describe '#host' do
        it 'returns a host' do
          endpoint.host.should match /amazon/
        end
      end

      describe '#marketplace' do
        it 'requires marketplace ID to have been set' do
          expect { endpoint.marketplace }.to raise_error MissingMarketplace
        end
      end

      describe '#seller' do
        it 'requires seller ID to have been set' do
          expect { endpoint.seller }.to raise_error MissingSeller
        end
      end

      describe '#path' do
        context 'when API type is set to Products' do
          before do
            endpoint.api = :products
          end

          it 'returns a URL path' do
            endpoint.path.should match %r{/\w+/\w+}
          end
        end

        context 'when API type is not implemented' do
          it 'raises a Not Implemented Error' do
            expect { endpoint.path }.to raise_error NotImplementedError
          end
        end
      end
    end
  end
end
