require 'spec_helper'

module Sucker
  describe Request do
    use_vcr_cassette 'spec/sucker/request', :record => :new_episodes

    let(:request) do
      Request.new(:locale        => :us,
                  :key           => 'key',
                  :secret        => 'secret',
                  :associate_tag => 'tag')
    end

    describe '#<<' do
      it 'merges a hash into the existing parameters' do
        request << { 'foo' => 'bar' }
        request.parameters['foo'].should eql 'bar'
      end
    end

    describe '#get' do
      it 'returns a response' do
        request.get.class.ancestors.should include Response
      end
    end

    describe "#reset" do
      it "resets parameters" do
        request << { 'foo' => 'bar' }
        request.reset

        request.parameters['Service'].should_not be_nil
        request.parameters['foo'].should be_nil
      end

      it "returns itself" do
        request.reset.should eql request
      end
    end

    describe '#url' do
      it 'builds a URL' do
        request.url.should be_an URI::HTTP
      end
    end

    describe '#version=' do
      it 'sets the Amazon API version' do
        request.version = 'foo'
        request.parameters['Version'].should eql 'foo'
      end
    end

    describe '#build_query_string' do
      let(:query) do
        request.send(:build_query_string)
      end

      it 'canonicalizes query' do
        query.should match /AWSAccessKeyId=key&AssociateTag=tag&Service=([^&]+)&Timestamp=([^&]+)&Version=([^&]+)/
      end

      it 'includes a timestamp' do
        query.should include 'Timestamp'
      end

      it 'sorts query' do
        request.parameters['A'] = 'foo'
        query.should match /^A=foo/
      end
    end

    describe '#sign' do
      let(:query) { request.send(:sign, 'foo=bar') }

      it 'returns a signed query string' do
        query.should include 'Signature='
      end
    end

    describe '#escape' do
      it 'URL-encodes a string' do
        request.send(:escape, 'foo,bar').should eql 'foo%2Cbar'
      end
    end

    describe "#host" do
      it "returns the host for specified locale" do
        request.locale = :uk
        request.send(:host).should eql Request::HOSTS[request.locale]
      end
    end
  end
end
