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

    describe "#associate_tag" do

      it "returns the associate tag for the current locale" do
        worker.instance_variable_set(:@associate_tags, { :us => 'foo-bar'})

        worker.associate_tag.should eql 'foo-bar'
      end

      it "returns nil if an associate tag is not set for the current locale" do
        worker.associate_tag.should eql nil
      end

    end

    describe "#associate_tags=" do

      it "sets associate tags for the locales" do
        tags = {
          :us => 'foo',
          :uk => 'bar',
          :de => 'baz',
          :ca => 'foo',
          :fr => 'bar',
          :jp => 'baz' }
        worker.associate_tags = tags

        worker.instance_variable_get(:@associate_tags).should eql tags
      end

    end

    describe "#curl_opts" do

      it "returns options for curl" do
        worker.curl_opts.should be_an_instance_of Hash
      end

      context "when given a block" do

        it "yields options for curl" do
          worker.curl_opts { |c| c.interface = "eth1" }

          worker.curl_opts[:interface].should eql "eth1"
        end

      end

    end

    describe "#get" do

      it "returns a response" do
        worker.get.class.ancestors.should include Response
      end

      it "raises an argument error if no key is provided" do
        worker.key = nil
        expect do
          worker.get
        end.to raise_error(/AWS access key missing/)
      end

      it "raises an argument error if no locale is provided" do
        worker.locale = nil
        expect do
          worker.get
        end.to raise_error(/Locale missing/)
      end
    end

    describe "#get_all" do

      it "returns an array of responses" do
        responses = worker.get_all

        responses.should be_an_instance_of Array
        responses.each { |resp| resp.should be_an_instance_of Response }
      end

      context "when given a block" do

        it "yields responses" do
          count = 0
          worker.get_all do |resp|
            resp.should be_an_instance_of Response
            count += 1
          end

          count.should eql Request::HOSTS.size
        end
      end
    end

    describe "#key" do

      it "returns the Amazon AWS access key for the current locale" do
        worker.instance_variable_set(:@keys, { :us => 'foo' })

        worker.key.should eql 'foo'
      end

    end

    describe "#key=" do

      it "sets a global Amazon AWS access key" do
        worker.key = "foo"
        keys = worker.instance_variable_get(:@keys)

        keys.size.should eql Request::HOSTS.size
        keys.values.uniq.should eql ["foo"]
      end

    end

    describe "#keys=" do

      it "sets distinct Amazon AWS access keys for the locales" do
        keys = {
          :us => 'foo',
          :uk => 'bar',
          :de => 'baz',
          :ca => 'foo',
          :fr => 'bar',
          :jp => 'baz' }
        worker.keys = keys

        worker.instance_variable_get(:@keys).should eql keys
      end

    end

    context "private methods" do

      describe "#build_query" do

        let(:query) { worker.send(:build_query) }

        it "canonicalizes parameters" do
          query.should match /Service=([^&]+)&Timestamp=([^&]+)&Version=([^&]+)/
        end

        it "includes the key for the current locale" do
          worker.instance_variable_set(:@keys, { :us => 'foo' })
          query.should include 'AWSAccessKeyId=foo'
        end

        it "includes a timestamp" do
          query.should include 'Timestamp='
        end

        it "sorts parameters" do
          worker.parameters["AAA"] = "foo"
          query.should match /^AAA=foo/
        end

        it "converts a parameter whose value is an array to a string" do
          worker.parameters["Foo"] = ["bar", "baz"]
          query.should match /Foo=bar%2Cbaz/
        end

        it "handles integer parameter values" do
          worker.parameters["Foo"] = 1
          query.should match /Foo=1/
        end

        it "handles floating-point parameter values" do
          worker.parameters["Foo"] = 1.0
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
