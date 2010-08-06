# encoding: utf-8
require "spec_helper"

module Sucker
  describe "Un lookup français" do
    before do
      @worker = Sucker.new(
        :locale => "fr",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      # @worker.curl { |curl| curl.verbose = true }

      @worker << {
        "Operation"     => "ItemLookup",
        "IdType"        => "ASIN",
        "Condition"     => "All",
        "MerchantId"    => "All",
        "ResponseGroup" => ["ItemAttributes", "OfferFull"] }

      Sucker.stub(@worker)
    end

    context "single item" do
      before do
        @worker << { "ItemId" => "2070119874" }
        @item = @worker.get.to_hash("Item").first
      end

      it "returns an item" do
        @item.should be_an_instance_of Hash
      end

      it "includes requested response groups" do
        @item["ItemAttributes"].should be_an_instance_of Hash
        @item["Offers"].should be_an_instance_of Hash
      end
    end

    context "multiple items" do
      before do
        @worker << { "ItemId" => ["0816614024", "0143105825"] }
        @items = @worker.get.to_hash("Item")
      end

      it "returns two items" do
        @items.should be_an_instance_of Array
        @items.size.should eql 2
      end
    end
  end
end
