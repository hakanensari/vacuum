require "spec_helper"

module Sucker
  describe "A Japanese request" do
    before do
      @worker = Sucker.new(
        :locale => "jp",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      @worker << {
        "Operation"     => "ItemLookup",
        "IdType"        => "ASIN",
        "ResponseGroup" => ["ItemAttributes", "OfferFull"] }

      Sucker.stub(@worker)
    end

    context "single item" do
      before do
        @worker << { "ItemId" => "482224816X" }
        @item = @worker.get.to_hash("Item").first
      end

      it "returns an array of items" do
        @item.should be_an_instance_of Hash
      end
    end
  end
end
