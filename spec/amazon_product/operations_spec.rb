require 'spec_helper'

module AmazonProduct
  describe Operations do
    subject { Request.new('us') }

    before do
      subject.configure do |c|
        c.key = 'foo'
        c.tag = 'bar'
      end
      subject.stub!(:get)
    end

    describe "#find" do
      before do
        subject.find('1', '2', :foo => 'bar')
      end

      it 'merges item ids' do
        subject.params['ItemId'].should eql '1,2'
      end

      it 'merges additional parameters' do
        subject.params['Foo'].should eql 'bar'
      end
    end

    describe "#find_browse_node" do
      before do
        subject.find_browse_node('123', :foo => 'bar')
      end

      it 'merges item ids' do
        subject.params['BrowseNodeId'].should eql '123'
      end

      it 'merges additional parameters' do
        subject.params['Foo'].should eql 'bar'
      end
    end

    describe "#find_similar" do
      before do
        subject.find_similar('1', '2')
      end

      it 'merges item ids' do
        subject.params['ItemId'].should eql '1,2'
      end
    end

    describe "#search" do
      context "when given a keyword" do
        before do
          subject.search('foo')
        end

        it "does a keyword search" do
          subject.params['Keywords'].should eql 'foo'
        end

        it "searches all products" do
          subject.params["SearchIndex"].should eql 'All'
        end
      end

      context "when given a search index and a keyword" do
        before do
          subject.search('foo', 'bar')
        end

        it "does a keyword search" do
          subject.params['Keywords'].should eql 'bar'
        end

        it "sets the search index" do
          subject.params["SearchIndex"].should eql 'foo'
        end
      end

      context "when given a search index and parameters" do
        before do
          subject.search('foo', :bar => 'baz')
        end

        it "sets the parameters" do
          subject.params['Bar'].should eql 'baz'
        end

        it "sets the search index" do
          subject.params["SearchIndex"].should eql 'foo'
        end
      end      
    end
  end
end
