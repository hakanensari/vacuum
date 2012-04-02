require 'spec_helper'

module Vacuum
  module Request
    describe ProductAdvertising do
      let(:request) do
        described_class.new do |config|
          config.key = 'key'
          config.secret = 'secret'
          config.tag = 'tag'
        end
      end

      it_behaves_like 'a request'

      describe '#find' do
        before do
          request.stub! :get
        end

        let(:parameters) do
          request.parameters
        end

        context 'given no items' do
          it 'raises an error' do
            expect { request.find }.to raise_error ArgumentError
          end
        end

        context 'given up to 10 items' do
          before do
            request.find *(1..10), :foo => 'bar'
          end

          it 'builds a single-batch query' do
            parameters['ItemId'].split(',').should =~ (1..10).map(&:to_s)
          end

          it 'takes parameters' do
            parameters['Foo'].should eql 'bar'
          end
        end

        context 'given 11 to to 20 items' do
          before do
            request.find *(1..20), :foo => 'bar'
          end

          it 'builds a multi-batch query' do
            first_batch = parameters['ItemId.1.ItemId'].split(',')
            first_batch.should =~ (1..10).map(&:to_s)
            second_batch = parameters['ItemId.2.ItemId'].split(',')
            second_batch.should =~ (11..20).map(&:to_s)
          end

          it 'takes parameters' do
            parameters['ItemLookup.Shared.Foo'].should eql 'bar'
          end
        end

        context 'given over 20 items' do
          it 'raises an error' do
            expect { request.find *(1..21) }.to raise_error ArgumentError
          end
        end
      end

      describe '#search' do
        let(:parameters) do
          request.parameters
        end

        context 'when given a search index and a keyword' do
          before do
            request.search :foo, 'bar'
          end

          it 'builds a keyword search' do
            parameters['Keywords'].should eql 'bar'
          end

          it 'sets the search index' do
            parameters['SearchIndex'].should eql 'Foo'
          end
        end

        context 'when given a search index and parameters' do
          before do
            request.search(:foo, :bar => 'baz')
          end

          it 'sets the parameters' do
            parameters['Bar'].should eql 'baz'
          end

          it 'sets the search index' do
            parameters['SearchIndex'].should eql 'Foo'
          end
        end
      end
    end
  end
end
