require "spec_helper"

module Sucker
  describe "Twenty items in one request" do
    use_vcr_cassette "integration/twenty_items", :record => :new_episodes

    let(:asins) do
      %w{
        0816614024 0143105825 0485113600 0816616779 0942299078
        0816614008 144006654X 0486400360 0486417670 087220474X
        0486454398 0268018359 1604246014 184467598X 0312427182
        1844674282 0745640974 0745646441 0826489540 1844672972 }
    end

    let(:items) do
      worker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      # Prep worker
      worker << {
        "Operation"                       => "ItemLookup",
        "ItemLookup.Shared.IdType"        => "ASIN",
        "ItemLookup.Shared.Condition"     => "All",
        "ItemLookup.Shared.MerchantId"    => "All",
        "ItemLookup.Shared.ResponseGroup" => "OfferFull" }

      # Push twenty ASINs to worker
      worker << {
        "ItemLookup.1.ItemId" => asins[0, 10],
        "ItemLookup.2.ItemId" => asins[10, 10] }

      worker.get.node("Item")
    end

    it "returns 20 items" do
      items.count.should eql 20
      items.map { |item| item["ASIN"] }.should eql asins
    end
  end
end
