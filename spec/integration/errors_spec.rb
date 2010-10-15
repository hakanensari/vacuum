require "spec_helper"

module Sucker
  describe "Errors" do
    use_vcr_cassette "integration/errors", :record => :new_episodes

    let(:response) do
      worker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      worker << {
        "Operation"     => "ItemLookup",
        "IdType"        => "ASIN",
        "Condition"     => "All",
        "MerchantId"    => "All",
        "ResponseGroup" => ["ItemAttributes"] }

      # The first ASIN exists, the latter two do not.
      worker << { "ItemId" => ["0816614024", "0007218095", "0007218176"] }
      worker.get
    end

    it "returns two errors" do
      errors = response.node("Error")
      errors.size.should eql 2
      errors.first["Message"].should include "not a valid value"
    end

    it "returns one item" do
      items = response.node("ItemAttributes")
      items.size.should eql 1
    end
  end
end
