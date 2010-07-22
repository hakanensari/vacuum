require "spec_helper"

module Sucker
  describe "Request" do
    before do
      @sucker = Sucker.new
    end

    context "public" do
      context ".new" do
        it "sets default parameters" do
          default_parameters = {
            "Service" => "AWSECommerceService",
            "Version" => Sucker::AMAZON_API_VERSION }
          @sucker.parameters.should eql default_parameters
        end
      end

      context "#<<" do
        it "merges a hash into the parameters" do
          @sucker << { "foo" => "bar" }
          @sucker.parameters["foo"].should eql "bar"
        end
      end

      context "#curl" do
        it "returns a cURL object" do
          @sucker.curl.should be_an_instance_of Curl::Easy
        end

        it "configures the cURL object" do
          @sucker.curl.interface.should be_nil

          @sucker.curl do |curl|
            curl.interface = "eth1"
          end

          @sucker.curl.interface.should eql "eth1"
        end
      end

      context "#fetch" do
        it "returns nil if valid? returns false" do
          @sucker.stub!(:valid?).and_return(false)
          @sucker.fetch.should be_nil
        end
      end

      context "#to_h" do
        before do
          @sucker.curl.stub!(:body_str).and_return(fixture("single_item_lookup.us"))
        end

        it "should return a hash" do
          @sucker.to_h.should be_an_instance_of Hash
        end
      end
    end

    context "private" do
      context "#build_query" do
        it "canonicalizes parameters" do
          query = @sucker.send(:build_query)
          query.should eql "Service=AWSECommerceService&Version=#{Sucker::AMAZON_API_VERSION}"
        end

        it "sorts parameters" do
          @sucker.parameters["Foo"] = "bar"
          query = @sucker.send(:build_query)
          query.should match /^Foo=bar/
        end

        it "converts a parameter whose value is an array to a string" do
          @sucker.parameters["Foo"] = ["bar", "baz"]
          query = @sucker.send(:build_query)
          query.should match /^Foo=bar%2Cbaz/
        end
      end

      context "#digest" do
        it "returns a digest object" do
          @sucker.send(:digest).should be_an_instance_of OpenSSL::Digest::Digest
        end
      end

      context "#key=" do
        it "sets the Amazon AWS access key in the parameters" do
          @sucker.key = "key"
          @sucker.parameters["AWSAccessKeyId"].should eql "key"
        end
      end

      context "#host" do
        it "returns a host" do
          @sucker.locale = "us"
          @sucker.send(:host).should eql "ecs.amazonaws.com"
        end
      end

      context "#path" do
        it "returns a path" do
          @sucker.send(:path).should eql "/onca/xml"
        end
      end

      context "#sign_query" do
        it "returns a signed query string" do
          @sucker.secret = "secret"
          @sucker.locale = "us"
          query = @sucker.send :sign_query
          query.should match /&Signature=.*/
        end
      end

      context "#timestamp_parameters" do
        it "upserts a timestamp to the parameters" do
          @sucker.send :timestamp_parameters
          @sucker.parameters["Timestamp"].should match /^\d+-\d+-\d+T\d+:\d+:\d+Z$/
        end
      end

      context "#uri" do
        it "returns the URI with which to query Amazon" do
          @sucker.key    = "key"
          @sucker.locale = "us"
          @sucker.secret = "secret"
          @sucker.send(:uri).should be_an_instance_of URI::HTTP
        end
      end

      context "valid?" do
        it "returns true if key, secret, and a valid locale are set" do
          @sucker.key    = "key"
          @sucker.locale = "us"
          @sucker.secret = "secret"
          @sucker.send(:valid?).should be_true
        end

        it "returns false if key is not set" do
          @sucker.locale = "us"
          @sucker.secret = "secret"
          @sucker.send(:valid?).should be_false
        end

        it "returns false if secret is not set" do
          @sucker.locale = "us"
          @sucker.key    = "key"
          @sucker.send(:valid?).should be_false
        end

        it "returns false if locale is not set" do
          @sucker.key    = "key"
          @sucker.secret = "secret"
          @sucker.send(:valid?).should be_false
        end

        it "returns false if locale is not valid" do
          @sucker.key    = "key"
          @sucker.locale = "US"
          @sucker.secret = "secret"
          @sucker.send(:valid?).should be_false
        end
      end
    end
  end
end
