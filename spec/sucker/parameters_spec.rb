require 'spec_helper'

module Sucker
  describe Parameters do
    let(:parameters) do
      Parameters.new
    end

    it "is a Hash" do
      Parameters.ancestors.should include Hash
    end

    context "when initialized" do
      it "sets `Service`" do
        parameters.should have_key "Service"
      end

      it "sets `Version`" do
        parameters.should have_key "Version"
      end
    end

    describe "#build" do
      it "canonicalizes query" do
        parameters.build.should match /Service=([^&]+)&Timestamp=([^&]+)&Version=([^&]+)/
      end

      it "includes a timestamp" do
        parameters.build.should include 'Timestamp'
      end

      it "sorts query" do
        parameters["A"] = "foo"
        parameters.build.should match /^A=foo/
      end
    end

    describe "#sign" do
      it "signs the query" do
        signed_query = parameters.sign('http://example.com', '/', 'secret')
        signed_query.should include 'Signature'
      end
    end

    describe "#timestamp!" do
      it "timestamps the query" do
        parameters.send(:timestamp!)
        parameters.should have_key "Timestamp"
        parameters["Timestamp"].should match /^\d+-\d+-\d+T\d+:\d+:\d+Z$/
      end
    end
  end
end
