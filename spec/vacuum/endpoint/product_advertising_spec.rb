require 'spec_helper'

module Vacuum
  module Endpoint
    describe ProductAdvertising do
      let(:endpoint) do
        described_class.new
      end

      it_behaves_like 'an endpoint'

      describe '#tag' do
        it 'requires tag to have been set' do
          expect { endpoint.tag }.to raise_error Vacuum::MissingTag
        end
      end
    end
  end
end
