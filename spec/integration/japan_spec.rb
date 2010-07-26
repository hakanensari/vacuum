require "spec_helper"

module Sucker
  describe "Japan" do
    before do
      @worker = Sucker.new(
        :locale => "jp",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      @worker << {
        "Operation"   => "ItemLookup",
        "IdType"      => "ASIN" }
    end

    context "single item" do
      before do
        @worker << { "ItemId" => "0816614024" }
        @item = @worker.get["ItemLookupResponse"]["Items"]["Item"]
      end

      it "returns an item" do
        @item.should be_an_instance_of Hash
      end
    end
  end
end
