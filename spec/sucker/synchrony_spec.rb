require 'spec_helper'

module Sucker
  describe 'Synchrony driver', :synchrony do
    before(:all) do
      require 'sucker/synchrony'
    end

    describe Request, :synchrony do
      let(:request) do
        Request.new(
          :locale => :us,
          :key    => 'key',
          :secret => 'secret')
      end

      it "uses an evented adapter" do
        request.adapter.should eql ::EM::HttpRequest
      end

      describe "#get" do
        it "returns a response" do
          EM.synchrony do
            response = request.get
            EM.stop
          end
        end
      end
    end
  end
end
