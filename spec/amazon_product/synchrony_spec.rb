require 'spec_helper'

module AmazonProduct
  describe 'Synchrony adapter', :synchrony do
    before(:all) do
      require 'amazon_product/synchrony'
    end

    describe Request, :synchrony do
      let(:request) do
        req = AmazonProduct['us']
        req.configure do |c|
          c.key    = 'foo'
          c.secret = 'bar'
          c.tag    = 'baz'
        end
        req
      end

      it "uses an evented adapter" do
        request.adapter.should eql ::EM::HttpRequest
      end

      describe "#aget" do
        it "yields a response" do
          response = nil
          EM.synchrony do
            request.aget { |resp| response = resp }
            EM.stop
          end

          response.should be_a Response
        end
      end

      describe "#get" do
        it "returns a response" do
          response = nil
          EM.synchrony do
            response = request.get
            EM.stop
          end

          response.should be_a Response
        end
      end
    end
  end
end
