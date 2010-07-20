require "spec_helper"

module Sucker
  describe "Item Lookup" do
    before(:each) do
      @sucker = Sucker::Request.new(
        :locale => "US",
        :key    => amazon["key"],
        :secret => amazon["secret"])

      @sucker.curl { |curl| curl.verbose = true }

      @sucker.parameters.merge!({
          "Operation"                 => "ItemLookup",
          "ItemLookup.1.ItemId"       => "9780485113358",
          "ItemLookup.Shared.IdType"  => "ISBN" })
    end

    it "" do
      p @sucker.fetch
    end
  end
end
