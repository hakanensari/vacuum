require 'spec_helper'

module Sucker
  describe Request do
    use_vcr_cassette 'spec/sucker/request', :record => :new_episodes

    let(:worker) do
      Sucker.new(
        :locale => :us,
        :key    => 'key',
        :secret => 'secret')
    end

    describe '#<<' do
      it 'merges a hash into the existing parameters' do
        worker << { 'foo' => 'bar' }
        worker.parameters['foo'].should eql 'bar'
      end
    end

    describe '#get' do
      it 'returns a response' do
        worker.get.class.ancestors.should include Response
      end

      context 'when local IP is specified' do
        before do
          worker.local_ip = '192.168.0.1'
        end

        it 'routes request through that IP' do
          pending('Figure out how to test this')
          worker.get
        end
      end
    end

    describe '#version=' do
      it 'sets the Amazon API version' do
        worker.version = 'foo'
        worker.parameters['Version'].should eql 'foo'
      end
    end

    describe '#build_query' do
      let(:query) do
        worker.send(:build_query)
      end

      it 'canonicalizes query' do
        query.should match /AWSAccessKeyId=key&AssociateTag=&Service=([^&]+)&Timestamp=([^&]+)&Version=([^&]+)/
      end

      it 'includes a timestamp' do
        query.should include 'Timestamp'
      end

      it 'sorts query' do
        worker.parameters['A'] = 'foo'
        query.should match /^A=foo/
      end
    end

    describe '#build_signed_query' do
      let(:query) { worker.send(:build_signed_query) }

      it 'includes the key for the current locale' do
        worker.key = 'foo'
        query.should include 'AWSAccessKeyId=foo'
      end

      it 'includes the associate tag for the current locale' do
        worker.associate_tag = 'foo'
        query.should include 'AssociateTag=foo'
      end

      it 'returns a signed query string' do
        query = worker.send :build_signed_query
        query.should include 'Signature='
      end
    end

    describe '#escape' do
      it 'URL-encodes a string' do
        worker.send(:escape, 'foo,bar').should eql 'foo%2Cbar'
      end
    end

    describe '#host' do
      it 'returns a host' do
        worker.locale = :fr
        worker.send(:host).should eql 'ecs.amazonaws.fr'
      end
    end
  end
end
