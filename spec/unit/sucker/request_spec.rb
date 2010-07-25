require "spec_helper"

module Sucker
  describe "Request" do
    before do
      @worker = Sucker.new
    end

    context "public" do
      context ".new" do
        it "sets default parameters" do
          default_parameters = {
            "Service" => "AWSECommerceService",
            "Version" => Sucker::AMAZON_API_VERSION }
          @worker.parameters.should eql default_parameters
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
          @worker.locale = "us"
          @worker.key = "key"
          @worker.secret = "secret"

          # Stub curl
          curl = @worker.curl
          curl.stub(:get).and_return(nil)
          curl.stub!(:body_str).and_return(fixture("single_item_lookup.us"))
        end

        it "returns a hash" do
          @worker.get.should be_an_instance_of Hash
        end

        it "raises an ArgumentError if valid? returns false" do
          @worker.stub!(:valid?).and_return(false)
          lambda{ @worker.get }.should raise_error ArgumentError
        end  
      end
    end

    context "private" do
      context "#build_query" do
        it "canonicalizes parameters" do
          query = @worker.send(:build_query)
          query.should eql "Service=AWSECommerceService&Version=#{Sucker::AMAZON_API_VERSION}"
        end

        it "sorts parameters" do
          @worker.parameters["Foo"] = "bar"
          query = @worker.send(:build_query)
          query.should match /^Foo=bar/
        end

        it "converts a parameter whose value is an array to a string" do
          @worker.parameters["Foo"] = ["bar", "baz"]
          query = @worker.send(:build_query)
          query.should match /^Foo=bar%2Cbaz/
        end
      end

      context "#digest" do
        it "returns a digest object" do
          @worker.send(:digest).should be_an_instance_of OpenSSL::Digest::Digest
        end
      end

      context "#key=" do
        it "sets the Amazon AWS access key in the parameters" do
          @worker.key = "key"
          @worker.parameters["AWSAccessKeyId"].should eql "key"
        end
      end

      context "#host" do
        it "returns a host" do
          @worker.locale = "us"
          @worker.send(:host).should eql "ecs.amazonaws.com"
        end
      end

      context "#path" do
        it "returns a path" do
          @worker.send(:path).should eql "/onca/xml"
        end
      end

      context "#sign_query" do
        it "returns a signed query string" do
          @worker.secret = "secret"
          @worker.locale = "us"
          query = @worker.send :sign_query
          query.should match /&Signature=.*/
        end
      end

      context "#timestamp_parameters" do
        it "upserts a timestamp to the parameters" do
          @worker.send :timestamp_parameters
          @worker.parameters["Timestamp"].should match /^\d+-\d+-\d+T\d+:\d+:\d+Z$/
        end
      end

      context "#uri" do
        it "returns the URI with which to query Amazon" do
          @worker.key    = "key"
          @worker.locale = "us"
          @worker.secret = "secret"
          @worker.send(:uri).should be_an_instance_of URI::HTTP
        end
      end

      context "valid?" do
        it "returns true if key, secret, and a valid locale are set" do
          @worker.key    = "key"
          @worker.locale = "us"
          @worker.secret = "secret"
          @worker.send(:valid?).should be_true
        end

        it "returns false if key is not set" do
          @worker.locale = "us"
          @worker.secret = "secret"
          @worker.send(:valid?).should be_false
        end

        it "returns false if secret is not set" do
          @worker.locale = "us"
          @worker.key    = "key"
          @worker.send(:valid?).should be_false
        end

        it "returns false if locale is not set" do
          @worker.key    = "key"
          @worker.secret = "secret"
          @worker.send(:valid?).should be_false
        end

        it "returns false if locale is not valid" do
          @worker.key    = "key"
          @worker.locale = "US"
          @worker.secret = "secret"
          @worker.send(:valid?).should be_false
        end
      end
    end
  end
end
