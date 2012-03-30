require 'spec_helper'

module Vacuum
  module Endpoint
    describe MWS do
      let(:endpoint) do
        described_class.new
      end

      it_behaves_like 'an MWS endpoint'

      describe '#path' do
        it 'is not implemented' do
          expect { endpoint.path }.to raise_error NotImplementedError
        end
      end
    end
  end
end
