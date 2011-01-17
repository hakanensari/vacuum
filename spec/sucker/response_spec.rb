# encoding: utf-8
require "spec_helper"

module Sucker
  describe Response do
    use_vcr_cassette "spec/sucker/response", :record => :new_episodes

    let(:asins) { ["0816614024", "0143105825"] }

    let(:response) do
      worker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])
      worker << {
          "Operation"     => "ItemLookup",
          "IdType"        => "ASIN",
          "ItemId"        => asins }
      worker.get
    end

    describe ".new" do
      it "initializes the response body" do
        response.body.should be_an_instance_of String
      end

      it "initializes the response code" do
        response.code.should == 200
      end

      it "initializes the response time" do
        response.time.should be_an_instance_of Float
      end

      it "initializes the request URI" do
        response.uri.should be_an_instance_of String
      end
    end

    describe "#each" do
      context "when a block is given" do
        it "yields each match to a block" do
          has_yielded = false

          response.each("ItemAttributes") do |item|
            has_yielded = true
            item.should be_an_instance_of Hash
          end

          has_yielded.should be_true
        end
      end

      context "when no block is given" do
        it "raises error" do
          expect do
            response.each("ItemAttributes")
          end.to raise_error(LocalJumpError)
        end
      end
    end

    context "when response contains errors" do
      before do
        response.body = "<?xml version=\"1.0\" ?><ItemLookupResponse xmlns=\"http://webservices.amazon.com/AWSECommerceService/2010-09-01\"><Errors><Error>foo</Error><Error>bar</Error></Errors>"
      end

      describe "#errors" do
        it "returns an array of errors" do
          response.errors.count.should eql 2
        end
      end

      describe "#has_errors?" do
        it "returns true if the response has errors" do
          response.should have_errors
        end
      end
    end

    describe "#find" do
      context "when there are matches" do

        it "returns an array of matching nodes" do
          response.find("ASIN").should eql asins
        end
      end

      context "when there are no matches" do
        it "returns an empty array" do
          node = response.find("Foo")
          node.should eql []
        end
      end
    end

    describe "#map" do
      context "when a block is given" do
        it "yields each match to a block and maps returned values" do
          titles = response.map("ItemAttributes") { |item| item["Title"] }

          titles.count.should eql 2
        end
      end

      context "when no block is given" do
        it "raises error" do
          expect do
            response.map("ItemAttributes")
          end.to raise_error(LocalJumpError)
        end
      end
    end

    describe "#to_hash" do
      it "returns a hash" do
        response.to_hash.should be_an_instance_of Hash
      end

      it "converts a content hash to string" do
        response.body = "<book><title>A Thousand Plateaus</title></book>"
        response.to_hash["book"]["title"].should be_an_instance_of String
      end

      it "renders French" do
        response.body = "<Title>L'archéologie du savoir</Title>"
        response.to_hash["Title"].should eql "L'archéologie du savoir"
      end

      it "renders German" do
        response.body = "<Title>Kafka: Für eine kleine Literatur</Title>"
        response.to_hash["Title"].should eql "Kafka: Für eine kleine Literatur"
      end

      it "renders Japanese" do
        response.body = "<Title>スティーブ・ジョブズ 驚異のプレゼン―人々を惹きつける18の法則</Title>"
        response.to_hash["Title"].should eql "スティーブ・ジョブズ 驚異のプレゼン―人々を惹きつける18の法則"
      end
    end

    describe "#valid?" do
      context "when HTTP status is OK" do
        it "returns true" do
          response.should be_valid
        end
      end

      context "when HTTP status is not OK" do
        it "returns false" do
          response.code = 403
          response.should_not be_valid
        end
      end
    end

    describe "#xml" do
      it "returns a Nokogiri document" do
        response.xml.should be_an_instance_of Nokogiri::XML::Document
      end
    end
  end
end
