require "spec_helper"

module Sucker
  describe Request do
    before do
      @worker = Sucker.new(
        :locale => "us",
        :key    => "key",
        :secret => "secret")
    end

    context ".new" do
      it "sets default parameters" do
        default_parameters = {
          "Service" => "AWSECommerceService",
          "Version" => Sucker::AMAZON_API_VERSION }
        @worker.parameters.should include default_parameters
      end
    end

    context "#<<" do
      it "merges a hash into the parameters" do
        @worker << { "foo" => "bar" }
        @worker.parameters["foo"].should eql "bar"
      end
    end

    context "#curl" do
      it "returns a cURL object" do
        @worker.curl.should be_an_instance_of Curl::Easy
      end

      it "configures the cURL object" do
        @worker.curl.interface.should be_nil

        @worker.curl do |curl|
          curl.interface = "eth1"
        end

        @worker.curl.interface.should eql "eth1"
      end
    end

    context "#get" do
      before do
        Sucker.stub(@worker)
      end

      it "returns a Response object" do
        @worker.get.class.ancestors.should include Response
      end
    end

    context "#key=" do
      it "sets the Amazon AWS access key in the parameters" do
        @worker.key = "foo"
        @worker.parameters["AWSAccessKeyId"].should eql "foo"
      end
    end

    context "private methods" do
      context "#build_query" do
        it "canonicalizes parameters" do
          query = @worker.send(:build_query)
          query.should match /Service=([^&]+)&Timestamp=([^&]+)&Version=([^&]+)/
        end

        it "sorts parameters" do
          @worker.parameters["AAA"] = "foo"
          query = @worker.send(:build_query)
          query.should match /^AAA=foo/
        end

        it "converts a parameter whose value is an array to a string" do
          @worker.parameters["Foo"] = ["bar", "baz"]
          query = @worker.send(:build_query)
          query.should match /Foo=bar%2Cbaz/
        end

        it "handles integer parameter values" do
          @worker.parameters["Foo"] = 1
          query = @worker.send(:build_query)
          query.should match /Foo=1/
        end

        it "handles floating-point parameter values" do
          @worker.parameters["Foo"] = 1.0
          query = @worker.send(:build_query)
          query.should match /Foo=1/
        end
      end

      context "#host" do
        it "returns a host" do
          @worker.locale = "fr"
          @worker.send(:host).should eql "ecs.amazonaws.fr"
        end
      end

      context "#build_signed_query" do
        it "returns a signed query string" do
          query = @worker.send :build_signed_query
          query.should match /&Signature=.*/
        end
      end

      context "#timestamp" do
        it "returns a timestamp" do
          @worker.send(:timestamp)["Timestamp"].should match /^\d+-\d+-\d+T\d+:\d+:\d+Z$/
        end
      end

      context "#uri" do
        it "returns the URI with which to query Amazon" do
          @worker.send(:uri).should be_an_instance_of URI::HTTP
        end
      end
    end
  end
end
