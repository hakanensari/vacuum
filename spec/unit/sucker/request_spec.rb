require "spec_helper"

module Sucker

  describe Request do

    use_vcr_cassette "unit/sucker/request", :record => :new_episodes

    let(:worker) do
      Sucker.new(
        :locale => "us",
        :key    => "key",
        :secret => "secret")
    end

    describe ".new" do

      it "sets default parameters" do
        default_parameters = {
          "Service" => "AWSECommerceService",
          "Version" => Sucker::CURRENT_AMAZON_API_VERSION }
        worker.parameters.should include default_parameters
      end

    end

    describe "#<<" do

      it "merges a hash into the parameters" do
        worker << { "foo" => "bar" }
        worker.parameters["foo"].should eql "bar"
      end

    end

    describe "#version=" do

      it "sets the Amazon API version" do
        worker.version = "foo"
        worker.parameters["Version"].should eql "foo"
      end

    end

    describe "#associate_tag=" do

      it "sets the associate tag in the parameters" do
        worker.associate_tag = "foo"
        worker.parameters["AssociateTag"].should eql "foo"
      end

    end

    describe "#curl" do

      it "returns curl" do
        worker.curl.should be_an_instance_of Curl::Easy
      end

      context "when given a block" do

        it "yields curl" do
          worker.curl.interface.should be_nil

          worker.curl { |curl| curl.interface = "eth1" }

          worker.curl.interface.should eql "eth1"
        end

      end

    end

    describe "#get!" do

      it "raises if response is not valid" do
        worker << {
          "Operation"     => "ItemLookup",
          "IdType"        => "ASIN",
          "ItemId"        => "0816614024" }
        lambda { worker.get! }.should raise_error ResponseError
      end

    end

    describe "#get" do

      it "returns a response" do
        worker.get.class.ancestors.should include Response
      end

    end

    describe "#key=" do

      it "sets the Amazon AWS access key in the parameters" do
        worker.key = "foo"
        worker.parameters["AWSAccessKeyId"].should eql "foo"
      end

    end

    context "private methods" do

      describe "#build_query" do

        it "canonicalizes parameters" do
          query = worker.send(:build_query)
          query.should match /Service=([^&]+)&Timestamp=([^&]+)&Version=([^&]+)/
        end

        it "sorts parameters" do
          worker.parameters["AAA"] = "foo"
          query = worker.send(:build_query)
          query.should match /^AAA=foo/
        end

        it "converts a parameter whose value is an array to a string" do
          worker.parameters["Foo"] = ["bar", "baz"]
          query = worker.send(:build_query)
          query.should match /Foo=bar%2Cbaz/
        end

        it "handles integer parameter values" do
          worker.parameters["Foo"] = 1
          query = worker.send(:build_query)
          query.should match /Foo=1/
        end

        it "handles floating-point parameter values" do
          worker.parameters["Foo"] = 1.0
          query = worker.send(:build_query)
          query.should match /Foo=1/
        end

      end

      describe "#host" do

        it "returns a host" do
          worker.locale = "fr"
          worker.send(:host).should eql "ecs.amazonaws.fr"
        end

      end

      describe "#build_signed_query" do

        it "returns a signed query string" do
          query = worker.send :build_signed_query
          query.should match /&Signature=.*/
        end

      end

      describe "#timestamp" do

        it "returns a timestamp" do
          worker.send(:timestamp)["Timestamp"].should match /^\d+-\d+-\d+T\d+:\d+:\d+Z$/
        end

      end

      describe "#uri" do

        it "returns the URI with which to query Amazon" do
          worker.send(:uri).should be_an_instance_of URI::HTTP
        end

      end

    end

  end

end
