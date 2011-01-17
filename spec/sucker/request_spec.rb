require "spec_helper"

module Sucker
  describe Request do
    use_vcr_cassette "spec/sucker/request", :record => :new_episodes

    let(:worker) do
      Sucker.new(
        :locale => :us,
        :key    => "key",
        :secret => "secret")
    end

    describe "#<<" do
      it "merges a hash into the existing parameters" do
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

      it "returns blank if no associate tag is set for the current locale" do
        worker.associate_tag.should be_blank
      end
    end

    describe "#associate_tag=" do
      it "sets the associate tag for the current locale" do
        worker.associate_tag = "foo-bar"
        associate_tags = worker.instance_variable_get(:@associate_tags)

        associate_tags.keys.size.should eql 1
        associate_tags[:us].should eql 'foo-bar'
        worker.associate_tag.should eql 'foo-bar'
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
      context "when no argument is passed" do
        it "returns a response" do
          worker.get.class.ancestors.should include Response
        end

        it "sets options on curl" do
          easy = mock
          easy.should_receive(:interface=).once.with("eth1")
          Curl::Easy.stub!(:perform).and_yield(easy)
          Response.should_receive(:new).once

          worker.curl_opts { |c| c.interface = 'eth1' }
          worker.get
        end
      end

      context "when one argument is passed" do
        context "when the argument is is `:all`" do
          it "queries all locales" do
            locales = worker.send(:locales)
            worker.should_receive(:get_multi).with(locales)
            worker.get(:all)
          end
        end

        context "when the argument is not `:all`" do
          it "sets current locale to to the argument" do
            worker.should_receive(:locale=).with(:uk)
            worker.get(:uk)
          end

          it "calls itself with no argument" do
            worker.class.send :alias_method, :get_original, :get
            worker.should_receive(:get).with(no_args())
            worker.get_original(:uk)
          end
        end
      end

      context "when multiple arguments are passed" do
        it "queries multiple locales" do
          worker.should_receive(:get_multi).with([:us, :uk])
          worker.get(:us, :uk)
        end
      end
    end

    describe "#key" do
      it "returns the Amazon AWS access key for the current locale" do
        worker.instance_variable_set(:@keys, { :us => 'foo' })

        worker.key.should eql 'foo'
      end

      it "raises an argument error if key is missing" do
        worker.instance_variable_get(:@keys)[:us] = nil
        expect do
          worker.key
        end.to raise_error 'AWS access key missing'
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

    describe "#locale" do
      it "returns the current locale" do
        worker.locale.should eql :us
      end

      it "raises an argument error if locale is not set" do
        worker.instance_variable_set(:@locale, nil)
        expect do
          worker.locale
        end.to raise_error 'Locale not set'
      end
    end

    describe "#locale=" do
      it "sets the current locale" do
        worker.locale= :uk
        worker.locale.should eql :uk
      end

      it "raises an argument error if locale is invalid" do
        expect do
          worker.locale= :br
        end.to raise_error 'Invalid locale'
      end
    end

    # private

    describe "#build_query" do
      let(:query) do
        worker.send(:build_query)
      end

      it "canonicalizes query" do
        query.should match /Service=([^&]+)&Timestamp=([^&]+)&Version=([^&]+)/
      end

      it "includes a timestamp" do
        query.should include 'Timestamp'
      end

      it "sorts query" do
        worker.parameters["A"] = "foo"
        query.should match /^A=foo/
      end
    end

    describe "#build_signed_query" do
      let(:query) { worker.send(:build_signed_query) }

      it "includes the key for the current locale" do
        worker.key = 'foo'
        query.should include 'AWSAccessKeyId=foo'
      end

      it "includes the associate tag for the current locale" do
        worker.associate_tag = 'foo'
        query.should include 'AssociateTag=foo'
      end

      it "returns a signed query string" do
        query = worker.send :build_signed_query
        query.should include 'Signature='
      end
    end

    describe "#escape" do
      it "URL-encodes a string" do
        worker.send(:escape, 'foo,bar').should eql "foo%2Cbar"
      end
    end

    describe "#get_multi" do
      it "returns an array of responses" do
        responses = worker.send(:get_multi, [:us, :uk])

        responses.should be_an_instance_of Array
        responses.each { |resp| resp.should be_an_instance_of Response }
      end

      context "when given a block" do
        it "yields responses" do
          locales = worker.send(:locales)
          count = 0
          worker.send(:get_multi, locales) do |resp|
            resp.should be_an_instance_of Response
            count += 1
          end

          count.should eql locales.size
        end
      end
    end

    describe "#host" do
      it "returns a host" do
        worker.locale = "fr"
        worker.send(:host).should eql "ecs.amazonaws.fr"
      end
    end

    describe "#uri" do
      it "returns the URI with which to query Amazon" do
        worker.send(:uri).should be_an_instance_of URI::HTTP
      end
    end
  end
end
