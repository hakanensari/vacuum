require 'spec_helper'

module Vacuum
  module Request
    describe Base do
      let(:request) do
        described_class.new do |config|
          config.key = 'key'
          config.secret = 'secret'
        end
      end

      it_behaves_like 'a request'

      describe '#url' do
        it 'is not implemented' do
          expect { request.url }.to raise_error NotImplementedError
        end
      end
    end
  end
end
