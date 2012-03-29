require 'spec_helper'

module Vacuum
  module Request
    describe ProductAdvertising do
      let(:request) do
        described_class.new do |config|
          config.key = 'key'
          config.secret = 'secret'
          config.tag = 'tag'
        end
      end

      it_behaves_like 'a request'
    end
  end
end
