require 'spec_helper'

module Vacuum
  describe Request do
    let_req

    describe '#<<' do
      before do
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

      it 'returns the request' do
        req.<<({ }).should eql req
      end
    end

    describe '#get' do
      it 'returns a response' do
        req.get.should be_a Response
      end
    end

    describe '#params' do
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
      it 'resets the request parameters' do
        req << { 'Key' => 'value' }
        req.params.should have_key 'Key'

        req.reset!
        req.params.should_not have_key 'Key'
      end

      it 'returns the request' do
        req.reset!.should eql req
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
    end
  end
end
