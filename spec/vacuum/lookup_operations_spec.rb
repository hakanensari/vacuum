require 'spec_helper'

module Vacuum
  describe LookupOperations do
    let_req

    before do
      req.stub!(:get)
    end

    describe "#find" do
      before do
        req.find('1', '2', :foo => 'bar')
      end

      it 'merges item ids' do
        req.params['ItemId'].should eql '1,2'
      end

      it 'merges additional parameters' do
        req.params['Foo'].should eql 'bar'
      end
    end

    describe "#find_browse_node" do
      before do
        req.find_browse_node('123', :foo => 'bar')
      end

      it 'merges item ids' do
        req.params['BrowseNodeId'].should eql '123'
      end

      it 'merges additional parameters' do
        req.params['Foo'].should eql 'bar'
      end
    end

    describe "#find_similar" do
      before do
        req.find_similar('1', '2')
      end

      it 'merges item ids' do
        req.params['ItemId'].should eql '1,2'
      end
    end
  end
end
