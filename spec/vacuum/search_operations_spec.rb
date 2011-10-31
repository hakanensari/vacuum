require 'spec_helper'

module Vacuum
  describe SearchOperations do
    let_req

    before do
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
