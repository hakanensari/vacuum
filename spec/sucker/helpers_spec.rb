require 'spec_helper'

module Sucker
  describe Helpers do
    let(:klass) do
      class Klass
        include Helpers
      end.new
    end

    describe "#camelize" do
      it "converts a symbol key to camelcased strings" do
        klass.camelize(:foo_bar).should eql "FooBar"
      end

      it "does not modify string keys" do
        klass.camelize("foo").should eql "foo"
      end
    end

    describe "#escape" do
      it "URL-encodes a string" do
        klass.escape('foo,bar').should eql "foo%2Cbar"
      end
    end

    describe "#stringify" do
      it "converts an array to a string of comma-separated values" do
        klass.stringify(['foo', 'bar']).should eql 'foo,bar'
      end

      it "casts a number as a string" do
        klass.stringify(1.5).should eql "1.5"
      end

      it "does not modify strings" do
        klass.stringify("foo").should eql "foo"
      end
    end
  end
end
