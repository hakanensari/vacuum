require 'spec_helper'

module AmazonProduct
  describe Request do
    let(:req) { Request.new('us') }

    describe '#<<' do
      before do
        req.configure do |c|
          c.key = 'foo'
          c.tag = 'bar'
        end

        req.reset!
      end

      it 'merges parameters into the query' do
        req << { 'Key' => 'value' }

        req.params['Key'].should eql 'value'
      end

      it 'camelizes keys' do
        req << { :some_key => 'value' }

        req.params.should have_key 'SomeKey'
      end

      it 'leaves camelized keys as is' do
        req << { 'SomeKey' => 'value' }

        req.params.should have_key 'SomeKey'
      end

      it 'casts numeric values to string' do
        req << { 'Key' => 1 }

        req.params['Key'].should eql '1'
      end

      it 'converts array values to string' do
        req << { 'Key' => ['foo', 'bar'] }

        req.params['Key'].should eql 'foo,bar'
      end

      it 'removes whitespace after commas in values' do
        req << { 'Key' => 'foo,  bar' }

        req.params['Key'].should eql 'foo,bar'
      end
    end

    describe '#configure' do
      it 'yields the locale' do
        req.configure(&:class).should eql Locale
      end
    end

    describe '#get' do
      before do
        req.configure do |c|
          c.key    = 'foo'
          c.secret = 'bar'
          c.tag    = 'baz'
        end
      end

      it 'returns a response' do
        req.get.should be_a Response
      end

      it 'raises an error if secret is missing' do
        req.configure { |c| c.secret = nil }

        expect { req.get }.to raise_error MissingSecret
      end
    end

    describe '#params' do
      before do
        req.configure do |c|
          c.key = 'foo'
          c.tag = 'bar'
        end
      end

      it 'raises an error if key is missing' do
        req.configure { |c| c.key = nil }

        expect { req.params }.to raise_error MissingKey
      end

      it 'raises an error if tag is missing' do
        req.configure { |c| c.tag = nil }

        expect { req.params }.to raise_error MissingTag
      end

      it 'includes common request parameters' do
        req.params['Service'].should eql 'AWSECommerceService'
      end

      it 'includes credentials' do
        req.params.should have_key 'AWSAccessKeyId'
        req.params.should have_key 'AssociateTag'
      end

      it 'includes a timestamp' do
        req.params['Timestamp'].should =~ /^\d+-\d+-\d+T\d+:\d+:\d+Z$/
      end

      context 'when no API version is specified' do
        it 'includes the current API version' do
          req.params['Version'].should eql Request::CURRENT_API_VERSION
        end
      end

      context 'when an API version is specified' do
        it 'includes the specified API version' do
          req << { 'Version' => '1' }
          req.params['Version'].should eql '1' 
        end
      end
    end

    describe '#reset!' do
      before do
        req.configure do |c|
          c.key = 'foo'
          c.tag = 'bar'
        end
      end

      it 'resets the request parameters' do
        req << { 'Key' => 'value' }
        req.params.should have_key 'Key'

        req.reset!
        req.params.should_not have_key 'Key'
      end
    end

    describe '#url' do
      before do
        req.configure do |c|
          c.key = 'foo'
          c.secret = 'bar'
          c.tag = 'baz'
        end
      end

      it 'builds a URL' do
        req.url.should be_a URI::HTTP
      end

      it 'canonicalizes the request parameters' do
        req.url.query.should match /\w+=\w+&/
      end

      it 'sorts the request parameters' do
        req << { 'A' => 1 }
        req.url.query.should match /^A=1&/
      end

      it 'URL-encodes values' do
        req << { :key => 'foo,bar' }
        req.url.query.should match /foo%2Cbar/
      end

      it 'signs the query' do
        req.url.query.should match /&Signature=/
      end

      it 'raises an error if no secret is specified' do
        expect do
          req.configure { |c| c.secret = nil }
          req.url
        end.to raise_error MissingSecret
      end
    end
  end
end
