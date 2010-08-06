require "spec_helper"

module Sucker
  describe "Errors" do
    before do
      worker = Sucker.new(
        :locale => "us",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      # worker.curl { |curl| curl.verbose = true }

      worker << {
        "Operation"     => "ItemLookup",
        "IdType"        => "ASIN",
        "Condition"     => "All",
        "MerchantId"    => "All",
        "ResponseGroup" => ["ItemAttributes"] }

      Sucker.stub(worker)

      # The first ASIN exists, the latter two do not.
      worker << { "ItemId" => ["0816614024", "0007218095", "0007218176"] }
      @response = worker.get
    end

    it "returns two errors" do
      errors = @response.to_hash("Error")
      errors.size.should eql 2
      errors.first["Message"].should include "not a valid value"
    end

    it "returns one item" do
      items = @response.to_hash("ItemAttributes")
      items.size.should eql 1
    end
  end
end
