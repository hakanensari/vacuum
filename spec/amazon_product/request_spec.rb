require 'spec_helper'

module AmazonProduct
  describe Request do

    subject { Request.new('us') }

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

      it 'casts numeric values to string' do
        subject << { 'Key' => 1 }
        subject.params['Key'].should eql '1'
      end

      it 'converts array values to string' do
        subject << { 'Key' => ['foo', 'bar'] }
        subject.params['Key'].should eql 'foo,bar'
      end
    end

    describe '#configure' do
      it 'configures the locale' do
        subject.configure do |c|
          c.key = 'foo'
        end

        locale = subject.locale
        locale.key.should eql 'foo'
      end
    end

    describe '#get' do
      before do
        subject.configure do |c|
          c.key = 'foo'
          c.secret = 'bar'
          c.tag = 'baz'
        end
      end

      it 'returns a response' do
        response = subject.get
        response.should be_a Response
      end
    end

    describe '#params' do
      context 'when no credentials are specified' do
        it 'raises an error' do
          expect do
            subject.params
          end.to raise_error MissingKey

          expect do
            subject.locale.key = 'foo'
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
        subject.locale.secret = 'baz'
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
