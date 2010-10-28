# encoding: utf-8
require "spec_helper"

module Sucker

  describe "Item lookup" do

    context "in France" do

      use_vcr_cassette "integration/france", :record => :new_episodes

      let(:item) do
        worker = Sucker.new(
          :locale => "fr",
          :key    => amazon["key"],
          :secret => amazon["secret"])

        worker << {
          "Operation"     => "ItemLookup",
          "IdType"        => "ASIN",
          "Condition"     => "All",
          "MerchantId"    => "All",
          "ResponseGroup" => ["ItemAttributes", "OfferFull"],
          "ItemId"        => "2070119874" }
        worker.get.find("Item").first
      end

      it "returns an item" do
        item.should be_an_instance_of Hash
      end

      it "includes requested response groups" do
        item["ItemAttributes"].should be_an_instance_of Hash
        item["Offers"].should be_an_instance_of Hash
        item["ItemAttributes"]["Binding"].should eql "Broché"
      end

    end

  end

end
