require "spec_helper"

module Sucker
  describe "Item lookup" do
    let(:worker) do
      worker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      worker << {
        "Operation"     => "ItemLookup",
        "IdType"        => "ASIN",
        "Condition"     => "All",
        "MerchantId"    => "All",
        "ResponseGroup" => ["ItemAttributes", "OfferFull"] }
      worker
    end

    context "single item" do
      use_vcr_cassette "integration/item_lookup/single", :record => :new_episodes

      let(:response) do
        worker << { "ItemId" => "0816614024" }
        worker.get
      end

      let(:item) { response.find("Item").first }

      it "returns an item" do
        item.should be_an_instance_of Hash
      end

      it "includes an ASIN string" do
        item["ASIN"].should eql "0816614024"
      end

      it "includes requested response groups" do
        item["ItemAttributes"].should be_an_instance_of Hash
        item["Offers"].should be_an_instance_of Hash
      end

      it "returns no errors" do
        response.find("Error").should be_empty
        response.find("Error").should be_an_instance_of Array
      end
    end

    context "multiple items" do
      use_vcr_cassette "integration/item_lookup/multiple", :record => :new_episodes

      let(:items) do
        worker << { "ItemId" => ["0816614024", "0143105825"] }
        worker.get.find("Item")
      end

      it "returns two items" do
        items.should be_an_instance_of Array
        items.size.should eql 2
      end
    end
  end
end
