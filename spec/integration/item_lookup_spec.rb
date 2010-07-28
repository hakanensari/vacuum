require "spec_helper"

module Sucker
  describe "Item lookup" do
    before do
      @worker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      # @worker.curl { |curl| curl.verbose = true }

      @worker << {
        "Operation"     => "ItemLookup",
        "IdType"        => "ASIN",
        "Condition"     => "All",
        "MerchantId"    => "All",
        "ResponseGroup" => "OfferFull" }
    end

    context "single item" do
      before do
        @worker << { "ItemId" => "0816614024" }
        @item = @worker.get["ItemLookupResponse"]["Items"]["Item"]
      end

      it "returns an item" do
        @item.should be_an_instance_of Hash
      end

      it "includes an ASIN string" do
        @item["ASIN"].should eql "0816614024"
      end

      it "includes the item attributes" do
        @item["ItemAttributes"].should be_an_instance_of Hash
      end
    end

    context "multiple items" do
      before do
        @worker << { "ItemId" => ["0816614024", "0143105825"] }
        @items = @worker.get["ItemLookupResponse"]["Items"]["Item"]
      end

      it "returns two items" do
        @items.should be_an_instance_of Array
        @items.size.should eql 2
      end
    end
  end
end
