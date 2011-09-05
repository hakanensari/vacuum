require 'spec_helper'

module AmazonProduct
  describe Request do
    subject { Request.new('us') }

    describe ".adapter" do
      it "defaults to :net_http" do
        Request.adapter.should eql :net_http
        expect { Net::HTTP }.not_to raise_error
      end
    end

    describe ".adapter=" do
      after do
        Request.adapter = :net_http
      end

      it "sets the adapter", :jruby do
        Request.adapter = :curb
        Request.adapter.should eql :curb
        defined?(Curl).should be_true
      end

      it "raises an error when specified an invalid adapter" do
        expect {
          Request.adapter = :foo
        }.to raise_error ArgumentError
      end
    end

    describe '#<<' do
      before do
        subject.configure do |c|
          c.key = 'foo'
          c.tag = 'bar'
        end
      end

      it 'merges parameters into the query' do
        subject << { 'Key' => 'value' }
        subject.params['Key'].should eql 'value'
      end

      it 'camelizes keys' do
        subject << { :some_key => 'value' }
        subject.params.should have_key 'SomeKey'
      end

      it 'does not modify already-camelized keys' do
        subject << { 'SomeKey' => 'value' }
        subject.params.should have_key 'SomeKey'
      end

      it 'casts numeric values to string' do
        subject << { 'Key' => 1 }
        subject.params['Key'].should eql '1'
      end

      it 'converts array values to string' do
        subject << { 'Key' => ['foo', 'bar'] }
        subject.params['Key'].should eql 'foo,bar'
      end
    end

    describe '#aget' do
      before do
        subject.configure do |c|
          c.key = 'foo'
          c.secret = 'bar'
          c.tag = 'baz'
        end
      end

      after do
        Request.adapter = :net_http
      end

      context 'when using Synchrony', :synchrony do
        before do
          Request.adapter = :synchrony
        end

        it 'yields a response' do
          response = nil
          EM.synchrony do
            subject.aget { |resp| response = resp }
            EM.stop
          end

          response.should be_a Response
        end
      end

      context 'when using another adapter' do
        it 'raises an error' do
          expect {
            subject.aget { }
          }.to raise_error TypeError
        end
      end
    end

    describe '#configure' do
      it 'yields the locale' do
        yielded = nil
        subject.configure do |c|
          yielded = c
        end
        yielded.should be_a Locale
      end
    end

    describe '#get' do
      shared_examples_for 'an HTTP request' do
        before do
          subject.configure do |c|
            c.key = 'foo'
            c.secret = 'bar'
            c.tag = 'baz'
          end
        end

        after do
          Request.adapter = :net_http
        end

        it 'returns a response' do
          if Request.adapter == :synchrony
            EM.synchrony do
              subject.get.should be_a Response
              EM.stop
            end
          else
            subject.get.should be_a Response
          end
        end
      end

      context 'when using Net::HTTP' do
        it_behaves_like 'an HTTP request'
      end

      context 'when using Curb', :jruby do
        before do
          Request.adapter = :curb
        end

        it_behaves_like 'an HTTP request'
      end

      context 'when using Synchrony', :synchrony do
        before do
          Request.adapter = :synchrony
        end

        it_behaves_like 'an HTTP request'
      end
    end

    describe '#params' do
      context 'when no credentials are specified' do
        it 'raises an error' do
          expect do
            subject.params
          end.to raise_error MissingKey

          expect do
            subject.configure do |c|
              c.key = 'foo'
            end
            subject.params
          end.to raise_error MissingTag
        end
      end

      context 'when credentials are specified' do
        before do
          subject.configure do |c|
            c.key = 'foo'
            c.tag = 'bar'
          end
        end

        it 'returns the request parameters' do
          subject.params['Service'].should eql 'AWSECommerceService'
        end

        it 'includes credentials' do
          subject.params.should have_key 'AWSAccessKeyId'
          subject.params.should have_key 'AssociateTag'
        end

        it 'includes a timestamp' do
          subject.params.should have_key 'Timestamp'
        end

        context 'when no API version is specified' do
          it 'includes the current API version' do
            subject.params['Version'].should eql Request::CURRENT_API_VERSION
          end
        end

        context 'when an API version is specified' do
          it 'includes that API version' do
            subject << { 'Version' => 'foo' }
            subject.params['Version'].should eql 'foo' 
          end
        end
      end
    end

    describe '#query' do
      before do
        subject.configure do |c|
          c.key = 'foo'
          c.tag = 'bar'
        end
      end

      it 'canonicalizes the request parameters' do
        subject.query.should match /\w+=\w+&/
      end

      it 'sorts the request parameters' do
        subject << { 'A' => 1 }
        subject.query.should match /^A=1&/
      end

      it 'URL-encodes values' do
        subject << { :key => 'foo,bar' }
        subject.query.should match /foo%2Cbar/
      end
    end

    describe '#reset' do
      before do
        subject.configure do |c|
          c.key = 'foo'
          c.tag = 'bar'
        end
      end

      it 'resets the request parameters' do
        subject << { 'Key' => 'value' }
        subject.params.should have_key 'Key'

        subject.reset
        subject.params.should_not have_key 'Key'
      end
    end

    describe '#sign' do
      it 'adds a signature to a query' do
        subject.configure do |c|
          c.secret = 'baz'
        end
        subject.sign('foo').should match /^foo&Signature=/
      end

      it 'raises an error if no secret is specified' do
        expect { subject.sign('foo') }.to raise_error MissingSecret
      end
    end

    describe '#timestamp' do
      it 'generates a timestamp' do
        subject.timestamp.should match /^\d+-\d+-\d+T\d+:\d+:\d+Z$/
      end
    end

    describe '#url' do
      before do
        subject.configure do |c|
          c.key = 'foo'
          c.secret = 'bar'
          c.tag = 'baz'
        end
      end

      it 'builds a URL' do
        subject.url.should be_a URI::HTTP
      end
    end
  end
end
