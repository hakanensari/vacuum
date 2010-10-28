require "spec_helper"

module Sucker

  describe "Item lookup" do

    context "when response group includes images" do

      use_vcr_cassette "integration/images", :record => :new_episodes

      let(:item) do
        worker = Sucker.new(
          :locale => "us",
          :key    => amazon["key"],
          :secret => amazon["secret"])

        worker << {
          "Operation"     => "ItemLookup",
          "IdType"        => "ASIN",
          "ResponseGroup" => "Images",
          "ItemId"        => "0816614024" }
        worker.get.find("Item").first
      end

      it "returns an ASIN" do
        item["ASIN"].should eql "0816614024"
      end

      it "returns a large image URL" do
        item["LargeImage"]["URL"].should match /^http.*jpg$/
      end

      it "returns an image set" do
        item["ImageSets"]["ImageSet"].should be_an_instance_of Hash
      end

    end

  end

end
