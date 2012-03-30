require 'spec_helper'

module Vacuum
  module Endpoint
    describe MWSProducts do
      let(:endpoint) do
        described_class.new
      end

      it_behaves_like 'an MWS endpoint'

      describe '#path' do
        it 'returns a URL path' do
          endpoint.path.should match %r{/\w+/\w+}
        end
      end
    end
  end
end
