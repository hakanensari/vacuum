# encoding: utf-8
require "spec_helper"

module Sucker
  describe Response do
    before do
      curl = Sucker.new.curl
      curl.stub(:get).and_return(nil)
      curl.stub!(:body_str).and_return('<?xml version="1.0" ?><books><book><creator role="author">Gilles Deleuze</author><title>A Thousand Plateaus</title></book><book><creator role="author">Gilles Deleuze</author><title>Anti-Oedipus</title></book></books>')
      curl.stub!(:response_code).and_return(200)
      curl.stub!(:total_time).and_return(1.0)
      @response = Sucker::Response.new(curl)
    end

    context ".new" do
      it "sets the response body" do
        @response.body.should be_an_instance_of String
      end

      it "sets the response code" do
        @response.code.should == 200
      end

      it "sets the response time" do
        @response.time.should be_an_instance_of Float
      end
    end

    context "to_h" do
      it "returns a hash" do
        @response.to_h.should be_an_instance_of Hash
      end

      it "converts a content hash to string" do
        @response.to_h["books"]["book"].first["title"].should be_an_instance_of String
      end

      it "is aliased as to_hash" do
        @response.to_hash.should eql @response.to_h
      end

      it "renders French" do
        @response.body = "<Title>L'archéologie du savoir</Title>"
        @response.to_h["Title"].should eql "L'archéologie du savoir"
      end

      it "renders German" do
        @response.body = "<Title>Kafka: Für eine kleine Literatur</Title>"
        @response.to_h["Title"].should eql "Kafka: Für eine kleine Literatur"
      end

      it "renders Japanese" do
        @response.body = "<Title>スティーブ・ジョブズ 驚異のプレゼン―人々を惹きつける18の法則</Title>"
        @response.to_h["Title"].should eql "スティーブ・ジョブズ 驚異のプレゼン―人々を惹きつける18の法則"
      end
    end
  end
end
