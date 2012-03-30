require 'spec_helper'

module Vacuum
  module Endpoint
    describe ProductAdvertising do
      let(:endpoint) do
        described_class.new
      end

      it_behaves_like 'an endpoint'

      describe '#host' do
        it 'returns a host' do
          endpoint.host.should match /amazon/
        end
      end

      describe '#tag' do
        it 'requires tag to have been set' do
          expect { endpoint.tag }.to raise_error MissingTag
        end
      end
    end
  end
end
