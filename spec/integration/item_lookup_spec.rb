require "spec_helper"

module Sucker
  describe "Item Lookup" do
    before do
      @sucker = Sucker.new(
        :locale => "US",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      @sucker.curl { |curl| curl.verbose = true }

      @sucker.parameters.merge!({
          "Operation"   => "ItemLookup",
          "IdType"      => "ISBN",
          "SearchIndex" => "Books" })
    end

    context "Single item" do
      before do
        @sucker.parameters.merge!({
          "ItemId" => "9780485113358"
        })
        @sucker.fetch
        @item = @sucker.to_h["ItemLookupResponse"]["Items"]["Item"]
      end

      it "returns an item" do
        @item.should be_an_instance_of Hash
      end

      it "includes an ASIN string" do
        @item["ASIN"].should eql "048511335X"
      end

      it "includes the item attributes" do
        @item["ItemAttributes"].should be_an_instance_of Hash
      end
    end

    context "Multiple items" do
      before do
        @sucker.parameters.merge!({
          "ItemId" => ["9780485113358", "9780143105824"]
        })
        @sucker.fetch
      end

      it "foos" do
        pp @sucker.to_h
      end
    end
  end
end
