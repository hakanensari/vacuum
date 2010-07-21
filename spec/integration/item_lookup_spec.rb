require "spec_helper"

module Sucker
  describe "Item Lookup" do
    before do
      @sucker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      # @sucker.curl { |curl| curl.verbose = true }

      @sucker.parameters.merge!({
          "Operation"   => "ItemLookup",
          "IdType"      => "ASIN"})
    end

    context "single item" do
      before do
        @sucker.parameters.merge!({
          "ItemId"      => "0816614024" })
        @sucker.fetch
        @item = @sucker.to_h["ItemLookupResponse"]["Items"]["Item"]
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
        @sucker.parameters.merge!({
          "ItemId"      => ["0816614024", "0143105825"] })
        @sucker.fetch
        @items = @sucker.to_h["ItemLookupResponse"]["Items"]["Item"]
      end

      it "returns two items" do
        @items.should be_an_instance_of Array
        @items.size.should eql 2
      end
    end
  end
end
