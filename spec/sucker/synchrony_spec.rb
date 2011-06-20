require 'spec_helper'
require 'sucker/synchrony'

module Sucker
  describe Request do
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
