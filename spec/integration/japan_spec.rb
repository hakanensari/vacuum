# encoding: utf-8
require "spec_helper"

module Sucker
  describe "A Japanese request" do
    use_vcr_cassette "integration/japan", :record => :new_episodes

    let(:item) do
      worker = Sucker.new(
        :locale => "jp",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      worker << {
        "Operation"     => "ItemLookup",
        "IdType"        => "ASIN",
        "ResponseGroup" => ["ItemAttributes", "OfferFull"],
        "ItemId"        => "482224816X" }
      worker.get.node("Item").first
    end

    it "returns an array of items" do
      item.should be_an_instance_of Hash
      item["ItemAttributes"]["Binding"].should eql "単行本（ソフトカバー）"
    end
  end
end
