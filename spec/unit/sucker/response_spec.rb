# encoding: utf-8
require "spec_helper"

module Sucker
  describe Response do
    use_vcr_cassette "unit/sucker/response", :record => :new_episodes

    let(:asins) { ["0816614024", "0143105825"] }

    let(:response) do
      worker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])
      worker << {
          "Operation"     => "ItemLookup",
          "IdType"        => "ASIN",
          "ResponseGroup" => ["ItemAttributes", "OfferFull"],
          "ItemId"        => asins }
      worker.get
    end

    context ".new" do
      it "sets the response body" do
        response.body.should be_an_instance_of String
      end

      it "sets the response code" do
        response.code.should == 200
      end

      it "sets the response time" do
        response.time.should be_an_instance_of Float
      end
    end

    context "#xml" do
      it "returns a Nokogiri document" do
        response.xml.should be_an_instance_of Nokogiri::XML::Document
      end
    end

    context "#node" do
      it "returns a collection of hashified nodes" do
        node = response.node("ItemAttributes")
        node.map { |book| book["ISBN"] }.should eql asins
      end

      it "returns an empty array if there are no matches" do
        node = response.node("Foo")
        node.should eql []
      end
    end

    context "#to_hash" do
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

    context "#valid?" do
      it "returns true if the HTTP status is OK" do
        response.should be_valid
      end

      it "returns false if the HTTP status is not OK" do
        response.code = 403
        response.should_not be_valid
      end
    end
  end
end
