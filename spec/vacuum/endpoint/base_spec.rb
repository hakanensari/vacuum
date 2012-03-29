require 'spec_helper'

module Vacuum
  module Endpoint
    describe Base do
      let(:endpoint) do
        described_class.new
      end

      it_behaves_like 'an endpoint'

      describe '#host' do
        it 'is not implemented' do
          expect { endpoint.host }.to raise_error NotImplementedError
        end
      end
    end
  end
end
