require "spec_helper"

module Sucker

  describe "Item lookup" do

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

    it "returns found items" do
      items = response.find("ItemAttributes")
      items.size.should eql 1
    end

    it "returns errors" do
      errors = response.find("Error")
      errors.size.should eql 2
      errors.first["Message"].should include "not a valid value"
    end

  end

end
