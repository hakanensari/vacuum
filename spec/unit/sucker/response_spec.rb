require "spec_helper"

module Sucker
  describe Response do
    before do
      curl = Sucker.new.curl
      curl.stub(:get).and_return(nil)
      curl.stub!(:body_str).and_return(fixture("multiple_item_lookup.us"))
      curl.stub!(:response_code).and_return(200)
      curl.stub!(:total_time).and_return(1.0)
      @response = Response.new(curl)
    end

    context ".new" do
      it "sets the response body" do
        @response.body.should be_an_instance_of String
      end

      it "sets the response code" do
        @response.code.should == 200
      end

      it "sets the response time" do
        @response.time.should be_an_instance_of Float
      end
    end

    context "to_h" do
      it "returns a hash" do
        @response.to_h.should be_an_instance_of Hash
      end
    end
  end
end