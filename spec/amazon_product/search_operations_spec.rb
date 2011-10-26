require 'spec_helper'

module AmazonProduct
  describe SearchOperations do
    let(:req) { Request.new('us') }

    before do
      req.configure do |c|
        c.key = 'foo'
        c.tag = 'bar'
      end
      req.stub!(:get)
    end

    describe "#search" do
      context "when given a keyword" do
        before do
          req.search('foo')
        end

        it "does a keyword search" do
          req.params['Keywords'].should eql 'foo'
        end

        it "searches all products" do
          req.params["SearchIndex"].should eql 'All'
        end
      end

      context "when given a search index and a keyword" do
        before do
          req.search('foo', 'bar')
        end

        it "does a keyword search" do
          req.params['Keywords'].should eql 'bar'
        end

        it "sets the search index" do
          req.params["SearchIndex"].should eql 'foo'
        end
      end

      context "when given a search index and parameters" do
        before do
          req.search('foo', :bar => 'baz')
        end

        it "sets the parameters" do
          req.params['Bar'].should eql 'baz'
        end

        it "sets the search index" do
          req.params["SearchIndex"].should eql 'foo'
        end
      end      
    end
  end
end
