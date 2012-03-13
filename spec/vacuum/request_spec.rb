require 'spec_helper'

module Vacuum
  describe Request do
    let(:req) do
      Request.new :locale => :us,
                  :key    => 'foo',
                  :secret => 'bar',
                  :tag    => 'baz'
    end

    describe ".new" do
      it 'raises an error if key is missing' do
        expect do
          Request.new :secret => 'foo',
                      :tag    => 'bar'
        end.to raise_error MissingKey
      end

      it 'raises an error if secret is missing' do
        expect do
          Request.new :key => 'foo',
                      :tag => 'bar'
        end.to raise_error MissingSecret
      end

      it 'raises an error if tag is missing' do
        expect do
          Request.new :key    => 'foo',
                      :secret => 'bar'
        end.to raise_error MissingTag
      end

      it 'raises an error if locale is not valid' do
        expect do
          Request.new :key    => 'foo',
                      :secret => 'bar',
                      :tag    => 'baz',
                      :locale => 'bad'
        end.to raise_error BadLocale
      end
    end

    describe '#build' do
      it 'merges parameters into the query' do
        req.build 'Key' => 'value'
        req.params['Key'].should eql 'value'
      end

      it 'casts values to string' do
        req.build 'Key' => 1
        req.params['Key'].should eql '1'

        req.build 'Key' => ['foo', 'bar']
        req.params['Key'].should eql 'foo,bar'
      end

      it 'returns self' do
        req.build({}).should eql req
      end
    end

    describe '#build!' do
      it 'clears existing query' do
        req.build 'Key' => 'value'
        req.params.should have_key 'Key'

        req
          .build!
          .params.should_not have_key 'Key'
      end
    end

    describe '#get' do
      it 'returns a response' do
        req.get.should be_a Response
      end
    end

    describe '#params' do
      it 'includes shared request parameters' do
        req.params['Service'].should eql 'AWSECommerceService'
      end

      it 'includes credentials' do
        req.params.should have_key 'AWSAccessKeyId'
        req.params.should have_key 'AssociateTag'
      end

      it 'includes a timestamp' do
        req.params['Timestamp'].should =~ /^\d+-\d+-\d+T\d+:\d+:\d+Z$/
      end

      context 'when no API version is given' do
        it 'includes the current API version' do
          req.params['Version'].should eql Request::CURRENT_API_VERSION
        end
      end

      context 'when an API version is given' do
        it 'includes the given API version' do
          req.build 'Version' => '1'
          req.params['Version'].should eql '1' 
        end
      end
    end

    describe '#url' do
      it 'builds a URL' do
        req.url.should be_a URI::HTTP
      end

      it 'canonicalizes the request parameters' do
        req.url.query.should match /\w+=\w+&/
      end

      it 'sorts the request parameters' do
        req.build 'A' => 1
        req.url.query.should match /^A=1&/
      end

      it 'URL-encodes values' do
        req.build 'Key' => 'foo,bar'
        req.url.query.should match /foo%2Cbar/
      end

      it 'is signed' do
        req.url.query.should match /&Signature=/
      end
    end
  end
end
