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
        "ResponseGroup" => ["ItemAttributes", "OfferFull"] }

      Sucker.stub(@worker)
    end

    context "single item" do
      before do
        @worker << { "ItemId" => "0816614024" }
        @response = @worker.get
        @item = @response.node("Item").first
      end

      it "returns an item" do
        @item.should be_an_instance_of Hash
      end

      it "includes an ASIN string" do
        @item["ASIN"].should eql "0816614024"
      end

      it "includes requested response groups" do
        @item["ItemAttributes"].should be_an_instance_of Hash
        @item["Offers"].should be_an_instance_of Hash
      end

      it "returns no errors" do
        @response.node("Error").should be_empty
        @response.node("Error").should be_an_instance_of Array
      end
    end

    context "multiple items" do
      before do
        @worker << { "ItemId" => ["0816614024", "0143105825"] }
        @items = @worker.get.node("Item")
      end

      it "returns two items" do
        @items.should be_an_instance_of Array
        @items.size.should eql 2
      end
    end
  end
end
