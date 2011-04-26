require 'spec_helper'

module Sucker
  describe Request do
    use_vcr_cassette 'spec/sucker/request', :record => :new_episodes

    let(:request) do
      Sucker.new(
        :locale => :us,
        :key    => 'key',
        :secret => 'secret')
    end

    describe ".locales" do
      it "returns available locales" do
        Request.locales.should =~ [:us, :uk, :de, :ca, :fr, :jp]
      end
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
      it "returns parameters to a pristine state" do
        request << { 'foo' => 'bar' }
        request.reset

        request.parameters.should have_key 'Service'
        request.parameters.should_not have_key 'foo'
      end

      it "returns the request object" do
        request.reset.should be_a Request
      end
    end

    describe '#version=' do
      it 'sets the Amazon API version' do
        request.version = 'foo'
        request.parameters['Version'].should eql 'foo'
      end
    end

    describe '#build_query' do
      let(:query) do
        request.send(:build_query)
      end

      it 'canonicalizes query' do
        query.should match /AWSAccessKeyId=key&AssociateTag=&Service=([^&]+)&Timestamp=([^&]+)&Version=([^&]+)/
      end

      it 'includes a timestamp' do
        query.should include 'Timestamp'
      end

      it 'sorts query' do
        request.parameters['A'] = 'foo'
        query.should match /^A=foo/
      end
    end

    describe '#build_signed_query' do
      let(:query) { request.send(:build_signed_query) }

      it 'includes the key for the current locale' do
        request.key = 'foo'
        query.should include 'AWSAccessKeyId=foo'
      end

      it 'includes the associate tag for the current locale' do
        request.associate_tag = 'foo'
        query.should include 'AssociateTag=foo'
      end

      it 'returns a signed query string' do
        query = request.send :build_signed_query
        query.should include 'Signature='
      end
    end

    describe '#escape' do
      it 'URL-encodes a string' do
        request.send(:escape, 'foo,bar').should eql 'foo%2Cbar'
      end
    end

    describe '#host' do
      it 'returns a host' do
        request.locale = :fr
        request.send(:host).should eql 'ecs.amazonaws.fr'
      end
    end
  end
end
