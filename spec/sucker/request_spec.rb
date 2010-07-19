require "spec_helper"

module Sucker
  describe "Request" do
    before(:each) do
      @request = Sucker::Request.new do |req|
        req.locale = "US"
        req.secret = "secret"
      end
    end

    it "sets default parameters" do
      default = {
        "Version" => Sucker::API_VERSION,
        "Service" => "AWSECommerceService" }
      @request.parameters.should eql default
    end

    context "#digest" do
      it "returns a digest object" do
        @request.send(:digest).should be_an_instance_of OpenSSL::Digest::Digest
      end
    end

    context "#host" do
      it "returns a host" do
        @request.locale = "US"
        @request.send(:host).should eql "http://ecs.amazonaws.com"
      end

      it "returns false if locale is not set" do
        @request.locale = nil
        @request.send(:host).should eql false
      end

      it "returns false if an incorrect locale is set" do
        @request.locale = "us"
        @request.send(:host).should eql false
      end
    end

    context "#query" do
      it "canonicalizes parameters" do
        @request.send(:query).should eql "Service=AWSECommerceService&Version=#{Sucker::API_VERSION}"
      end

      it "sorts parameters" do
        @request.parameters["Foo"] = "bar"
        @request.send(:query).should match /^Foo=bar/
      end
    end

    context "#sign" do
      it "signs a query" do
        @request.send :sign
        @request.parameters["Signature"].should_not be_nil
      end

      it "returns false if secret is not set" do
        @request.secret = nil
        @request.parameters["Signature"].should be_false
      end

      it "returns false if locale is not set" do
        @request.locale = nil
        @request.parameters["Signature"].should be_false
      end
    end

    context "#timestamp" do
      it "timestamps a query" do
        @request.send :timestamp
        @request.parameters["Timestamp"].should eql Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
      end
    end
  end
end
